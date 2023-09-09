# FIG: Follow Iron Golems Behavior Pack

Track statistics useful for iron farms.

## Summary

FIG is a behavior pack for Minecraft Bedrock that tracks statistics useful for
understanding iron farms. It tracks the the number of iron golems spawning,
where they spawn, and how many ticks they live. It estimates both average age
and variance in age of iron golems.

## Quick Start

In world settings, activate the FIG behavior pack and enable cheats. Then issue
the following commands from the console:
```
/function fig/setup
/function fig/start
```

When you are done tracking golems, you can ask that FIG to stop gracefully after
any iron golems that are currently alive die:
```
/function fig/stop
```
After stopping, you can run `fig/start` again to continue tracking golems.

And if you need to reset your statistics to run another test, you can use the
following command:
```
/function fig/reset
```

## Statistics

FIG tracks ten statistics.

 - Time: the number of ticks FIG has run.
 - NumGolems: The number of iron golems that have spawned.
 - SumAge: The sum of the ages of iron golems
 - SumAgeSq: The sum of the squared-ages of iron golems
 - NumSpots: The number of unique spawn spots found in the farm.
 - NumVillagers: The number of villagers in the farm.
 - AvgAge_x100: The average lifetime of iron golems to 2 decimal places. A
   value of 25010 is 250.10 ticks.
 - AvgAgeHi\_x100 and AvgAgeLo\_x100: The 95% confidence interval for the estimate
   of the average age.
 - VarAge_x100: The variance in the lifetime of iron golems to 2 decimal places.

Additionally, FIG will mark the spawn location of iron golems enabling players
to figure out the dimensions of their spawnable area.

Note that you can get more precise estimates of AvgAge\_x100, AvgAgeHi\_x100, 
AvgAgeLo\_x100 and VarAge\_x100 if you calculate them yourself from SumAge,
SumAgeSq and NumGolems.

## Command Functions

### `fig/setup` and `fig/reset`

These functions create/reset scoreboards. They also turn off mob spawning and
replace any emerald blocks in the spawning platform with iron blocks.

### `fig/start`

This function turns on mob spawning and tells FIG to start tracking iron golems
when it detects that there are no iron golems. It also kills any existing iron
golems.

### `fig/stop`

This function turns off mob spawning and tells FIG to start tracking iron golems
when it detects that there are no iron golems.

## Calculating Iron Farm Rates

In order to calculate the production rate of an iron farm, you need to know
three things
 - The number of spawnable blocks, which is detectable from the emerald blocks
   that FIG places down. It can take a long time for every spawnable block to
   be counted. However, after running a farm for 2 or 3 hours you should be
   able to know the approximate size of the spawning area taking into account
   obstructions along the edges or in the middle of the platform.
 - The total number of villagers, which is reported by FIG.
 - The average lifetime of a golem in ticks, which is also reported by FIG.

Consider the following example. There are 20 villagers, 210 spawnable blocks,
and an AvgAge_x100 of 27240. We can calculate the ingots/hour produced by this
farm as

```r
iron_farm_rate(210, 272.40, 20) # result is 390.17
```

We can go further and use the 95% CI of our average age estimate to estimate how
precise our estimate is:
```r
iron_farm_rate(210, 269.51, 20) # result is 390.52 using AvgAgeLo_x100
iron_farm_rate(210, 275.31, 20) # result is 389.79 using AvgAgeHi_x100
```

### Iron Farm Rate function

As I explained in [Iron Farm Mechanics in Minecraft Bedrock — Part 2: Advanced
Mechanics and Rates](https://youtu.be/c_tdRhUmt7w), iron farms can be analyzed
as a [birth-death process](https://en.wikipedia.org/wiki/Birth%E2%80%93death_process).
We can use the mechanics of iron farms and the solutions for birth-death
processes to calculate the rate of an iron farm very accurately.

You can use [this google sheet](https://docs.google.com/spreadsheets/d/1zmiGbM693c8nROf70GSGrlyeh_ZffTxdhCXASQvpnyo/edit?usp=sharing)
to calculate how much iron your iron farm generates per hour based on FIG statistics.
Download or make a copy of the sheet if you want to use it to calculate rates.

Alternatively, you can use this R function to calculate the rate.

```r
# Source: https://en.wikipedia.org/wiki/Birth%E2%80%93death_process#Stationary_solution
iron_farm_rate <- function(num_blocks, golem_lifetime, num_villagers=20, time_span=72000) {
    max_blocks <- 17*17
    s <- 1 - (1-num_blocks/max_blocks)^10 # spawn eff
    m <- num_villagers %/% 10

    lambda <- s/700 # net spawning rate
    mu <- 1/golem_lifetime # kill rate

    # ratios of lambda_{i-1} / mu_{i}
    q <- lambda/(mu*(1:m))
    qq <- cumprod(q)

    # birth-death model
    pi_m <- qq[m] / (1 + sum(qq))

    lambda*(1-pi_m)*time_span*4 
}
```

## Acknowledgements

FIG uses a sqrt function modified from the Mathematical Functions Datapack by
yosho27.
