# A durationMs that reaches back hours before its turn's first record counts from the turn's own start (39fa490).
rec prompt 01:00:00 1
rec close  01:05:00 300000
rec prompt 10:00:00 2
rec close  10:04:00 32820000   # 547 min, back before the session started
run session-times.sh s1
