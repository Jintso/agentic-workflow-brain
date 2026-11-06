# A message queued into a running turn has the turn's turnIndex and doesn't restart it (39fa490).
rec prompt 10:00:00 1
rec reply  10:02:00
rec prompt 10:03:00 1
rec close  10:05:00 120000
run session-times.sh s1
