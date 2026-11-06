# Closed turns run from their prompt to their turn_duration; two that overlap are counted once.
rec prompt 10:00:00 1
rec reply  10:05:00
rec close  10:10:00 600000
rec close  10:20:00 900000     # no turn open: 10:05 to 10:20, over the first
rec prompt 11:00:00 2
rec reply  11:29:00
rec close  11:30:00 1800000
run session-times.sh s1
