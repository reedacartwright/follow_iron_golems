scoreboard players operation k4 math = ret math
scoreboard players operation k3 math = in_w math
scoreboard players operation k3 math /= ret math
scoreboard players operation ret math += k3 math
scoreboard players operation ret math /= k2 math
scoreboard players operation k4 math -= ret math
execute unless score k4 math matches -1..1 run function math/_esqrt
