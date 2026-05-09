( .model.display_name // "?" )                          as $model |
( .context_window.used_percentage // 0 | floor )        as $pct   |
( .cost.total_cost_usd // 0 | . * 1000 | round / 1000 ) as $cost  |
"\($model) | ctx \($pct)% | $\($cost)"
