scoreboard players operation arg math = var_age fig_global
scoreboard players operation arg math *= hundred fig_global
scoreboard players operation arg math /= sum_golems fig_global
function math/sqrt
scoreboard players operation ci_mean_age fig_global = ret math
scoreboard players operation ci_mean_age fig_global += ci_mean_age fig_global

# update results for standard deviation
scoreboard players operation AvgAgeHi_x100 fig_results = avg_age fig_global
scoreboard players operation AvgAgeHi_x100 fig_results += ci_mean_age fig_global
scoreboard players operation AvgAgeLo_x100 fig_results = avg_age fig_global
scoreboard players operation AvgAgeLo_x100 fig_results -= ci_mean_age fig_global