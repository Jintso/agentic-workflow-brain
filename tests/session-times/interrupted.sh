# Gap 20: an interactive turn interrupted before its turn_duration ends at its last record before the next prompt.
rec prompt 10:00:00 1
rec reply  10:05:00
rec prompt 10:30:00 2
rec close  10:40:00 600000
run session-times.sh s1
