# Setup Scoreboards
scoreboard objectives add math dummy
scoreboard objectives add fig_global dummy
scoreboard objectives add fig_results dummy "  FIG RESULTS  "
scoreboard objectives add fig_age dummy
scoreboard objectives add fig_temp dummy
scoreboard objectives setdisplay sidebar fig_results
scoreboard objectives setdisplay list fig_results

# Setup the State to Off
scoreboard players set fig_state fig_global 0

# Setup Global Variables
scoreboard players set sum_age fig_global 0
scoreboard players set sum_agesq fig_global 0
scoreboard players set sum_golems fig_global 0
scoreboard players set timer fig_global 0
scoreboard players set platform fig_global 0
scoreboard players set hundred fig_global 100

scoreboard players reset * fig_results

# Turn off mob spawning until we start recording
gamerule domobspawning false

# Replace emerald blocks with iron blocks
execute at @e[type=villager] run fill ~-8 ~-6 ~-8 ~8 ~6 ~8 iron_block [] replace emerald_block
