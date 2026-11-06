# A last turn with no closing record counts up to the last record, and the lines say "and the running one" (39fa490).
rec prompt 10:00:00 1
rec close  10:10:00 600000
rec prompt 11:00:00 2
rec reply  11:20:00
run session-times.sh s1
