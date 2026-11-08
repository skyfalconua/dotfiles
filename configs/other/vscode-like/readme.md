### install extensions

bash

```sh
  for e in `cat user-settings/extensions.txt`; do code --install-extension $e; done

  for e in `cat user-settings/extensions.txt`; do  antigravity --install-extension $e; done
```

powershell

```powershell
  Get-Content user-settings/extensions.txt | ForEach-Object { code --install-extension $_ }

  Get-Content user-settings/extensions.txt | ForEach-Object { code --install-extension $_ }
```
