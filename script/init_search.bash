# setup s3
curl -sS -H 'Content-Type: application/json' -X PUT "http://search.homepage2:9200/_snapshot/backup"  -d '
{
        "type": "s3",
        "settings": {
                "bucket": "hiroyuki.sano.ninja",
                "base_path": "tmp/search/snapshots",
                "compress": "true"
        }
}'
