# A session in its first turn, with none completed, says "the running turn", not "0 completed turns and the running one".
rec prompt 10:00:00 1
rec reply  10:20:00
run session-times.sh s1
