import fs from 'node:fs';

function github(repo, pth) {
  return `https://raw.githubusercontent.com/${repo}/refs/heads/main/${pth}`;
}

function* jsoncCharacters(source) {
  let i = 0;
  while (i < source.length) {
    // String literal
    if (source[i] === '"') {
      yield source[i++];
      while (i < source.length) {
        if (source[i] === '\\') {
          yield source[i++]; // backslash
          const sym = source[i++]; yield sym;
          if (sym === 'u') { // escaped quote like \u0022
            for (let j = 0; j < 4; j++) yield source[i++];
          }
          continue;
        }
        if (source[i] === '"') { yield source[i++]; break; }
        yield source[i++];
      }
      continue;
    }
    // Line comment
    if (source[i] === '/' && source[i + 1] === '/') {
      while (i < source.length && source[i] !== '\n') i++;
      continue;
    }
    // Block comment
    if (source[i] === '/' && source[i + 1] === '*') {
      i += 2;
      while (i < source.length - 1 && !(source[i] === '*' && source[i + 1] === '/')) i++;
      i += 2;
      continue;
    }
    yield source[i++];
  }
}

function stripComments(source) {
  return Array.from(jsoncCharacters(source)).join('');
}

async function fetchJSON(url) {
  const res = await fetch(url);
  const text = await res.text();
  return JSON.parse(stripComments(text));
}

const EXCLUDED_TERMINAL_KEYS = [
  'terminal.background',
  'terminal.foreground',
];

function mergeThemes(base, override) {
  const baseTheme = base.themes[0];
  const overrideTheme = override.themes[0];
  const newName = `${base.name} | ${overrideTheme.name}`;

  const mergedStyle = {
    ...baseTheme.style,
    syntax: overrideTheme.style.syntax
  };
  for (const key of Object.keys(mergedStyle)) {
    if (key.startsWith('terminal.') && !EXCLUDED_TERMINAL_KEYS.includes(key)) {
      mergedStyle[key] = overrideTheme.style[key] || mergedStyle[key];
    }
  }

  const merged = {
    name: newName,
    author: `${base.author} | ${override.author}`,
    themes: [
      {
        ...baseTheme,
        name: newName,
        style: mergedStyle
      }
    ]
  };

  return merged;
}

async function main() {
  const baseUrl = github('pavles6/one-dark-darkened', 'themes/one-dark-darkened.json');
  const overrideUrl = github('kpitt/zed-theme-intellij-newui', 'themes/intellij-newui.json');

  console.log('Fetching base theme...');
  const base = await fetchJSON(baseUrl);

  console.log('Fetching override theme...');
  const override = await fetchJSON(overrideUrl);

  console.log('Merging themes...');
  const merged = mergeThemes(base, override);

  fs.writeFileSync('themes/my-mixed-theme.json', JSON.stringify(merged, null, 2));
  console.log('Saved to my-mixed-theme.json');
}

main().catch(err => {
  console.error('Error:', err.message);
  process.exit(1);
});
