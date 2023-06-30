# Let's do some math for a variance semiring
# age' = age + 1
# agesq' = (age+1)^2 = agesq + 2*age + 1
# 
# sum(age)' = sum(age) + N
# sum(agesq)' = sum(agesq) + 2*sum(age) + N

# update age, sum_age, and sum_agesq
scoreboard players operation sum_agesq fig_global += @e[type=iron_golem] fig_age
scoreboard players add @e[type=iron_golem] fig_age 1
scoreboard players operation sum_agesq fig_global += @e[type=iron_golem] fig_age
execute as @e[type=iron_golem] run scoreboard players add sum_age fig_global 1

# update stats for newly spawned golems
scoreboard players operation sum_golems fig_global += @e[type=iron_golem, scores={fig_age=1}] fig_age
execute at @e[type=iron_golem, scores={fig_age=1}] unless block ~0.5 ~-1 ~0.5 emerald_block run scoreboard players add platform fig_global 1
execute at @e[type=iron_golem, scores={fig_age=1}] run setblock ~0.5 ~-1 ~0.5 emerald_block

# update number of ticks
scoreboard players add timer fig_global 1

# update number of villagers
scoreboard players set num_villagers fig_global 0
execute as @e[type=villager_v2] run scoreboard players add num_villagers fig_global 1

# calculate average age
scoreboard players operation avg_age fig_global = sum_age fig_global
scoreboard players operation avg_age fig_global *= hundred fig_global
scoreboard players operation avg_age fig_global /= sum_golems fig_global

# calculate variance in age
scoreboard players operation n_minus_1 fig_temp = sum_golems fig_global
scoreboard players remove n_minus_1 fig_temp 1

scoreboard players operation v1 fig_temp = sum_age fig_global
scoreboard players operation v1 fig_temp /= sum_golems fig_global
scoreboard players operation v1 fig_temp *= sum_age fig_global

scoreboard players operation v2 fig_temp = sum_age fig_global
scoreboard players operation v2 fig_temp %= sum_golems fig_global
scoreboard players operation v2 fig_temp *= sum_age fig_global
scoreboard players operation v2 fig_temp /= sum_golems fig_global

scoreboard players operation var_age fig_global = sum_agesq fig_global
scoreboard players operation var_age fig_global -= v1 fig_temp
scoreboard players operation var_age fig_global -= v2 fig_temp
scoreboard players operation var_age fig_global *= hundred fig_global
scoreboard players operation var_age fig_global /= n_minus_1 fig_temp

# calculate standard deviation
scoreboard players operation arg math = var_age fig_global
scoreboard players operation arg math *= hundred fig_global
scoreboard players operation arg math /= sum_golems fig_global
function math/sqrt
scoreboard players operation ci_mean_age fig_global = ret math
scoreboard players operation ci_mean_age fig_global += ci_mean_age fig_global

# update results
scoreboard players operation SumAge fig_results = sum_age fig_global
scoreboard players operation SumAgeSq fig_results = sum_agesq fig_global
scoreboard players operation NumGolems fig_results = sum_golems fig_global
scoreboard players operation NumVillagers fig_results = num_villagers fig_global
scoreboard players operation Time fig_results = timer fig_global
scoreboard players operation NumSpots fig_results = platform fig_global
scoreboard players operation AvgAge_x100 fig_results = avg_age fig_global
scoreboard players operation VarAge_x100 fig_results = var_age fig_global
scoreboard players operation AvgAgeHi_x100 fig_results = avg_age fig_global
scoreboard players operation AvgAgeHi_x100 fig_results += ci_mean_age fig_global
scoreboard players operation AvgAgeLo_x100 fig_results = avg_age fig_global
scoreboard players operation AvgAgeLo_x100 fig_results -= ci_mean_age fig_global
