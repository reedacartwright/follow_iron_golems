# `fig_state` represents the state that fig is currently in. It has four
# possible values:
#  - 0 = OFF
#  - 1 = START_REQUESTED
#  - 2 = ON
#  - 3 = STOP_REQUESTED


# if a stop is requested, stop when there are no more golems
execute if score fig_state fig_global matches 3 unless entity @e[type=iron_golem] run scoreboard players set fig_state fig_global 0

# if a start is requested, start when there are no more golems
execute if score fig_state fig_global matches 1 unless entity @e[type=iron_golem] run scoreboard players set fig_state fig_global 2

# run tick operations if fig is in one of the ON states
execute unless score fig_state fig_global matches 0..1 run function fig/zzz/handle_ontick
