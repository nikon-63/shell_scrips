# NetCheck

## Files

* `netcheck_log.sh`: Runs DNS + HTTP(S) checks against a configurable list of targets and appends structured results to a log file.
* `netcheck_report.sh`: Parses the log file, highlights failed checks, and summarizes pass/fail counts per target.

## Usage

Run the logger manually:

```bash
./netcheck_log.sh
```

Check the latest results:

```bash
./netcheck_report.sh
```

## Automating with crontab

To run the logger every 5 minutes:

```cron
*/5 * * * * /home/ubuntu/netcheck/netcheck_log.sh 2>&1
```


