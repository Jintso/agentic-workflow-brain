# A past session ends at its last record, and a file-history snapshot written after it is left out (54775f0).
rec prompt   10:00:00 1
rec snapshot 10:00:00.001
rec reply    10:29:00
rec close    10:30:00 1800000
rec snapshot 10:45:00
run session-times.sh s1
