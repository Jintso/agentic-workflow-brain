# A transcript with no turnOrigin records: a turn runs durationMs back from its turn_duration.
rec reply 10:00:00
rec close 10:10:00 300000
rec reply 10:20:00
rec close 10:30:00 600000
run session-times.sh s1
