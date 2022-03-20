import feedparser, csv, psycopg2, os

def get_connection():
    database = os.environ.get('DATABASE_NAME')
    user = os.environ.get('DATABASE_USER')
    password = os.environ.get('DATABASE_PASSWORD')
    host = os.environ.get('DATABASE_HOST')
    port = os.environ.get('DATABASE_PORT')

    return psycopg2.connect(dbname = database, user=user, password=password, host=host, port=port)

def make_tag_cache(conn):
    result = {}
    with conn.cursor() as cur:
        cur.execute('SELECT id, name from cloudupdate.aws_blog_tag')
        rows = cur.fetchall()
        for tag in rows:
            result[tag[1]] = tag[0]
    return result

def aws_blog_fetch_feed():
    filename = "aws-feed.csv"
    with open(filename) as fp:
        reader = csv.reader(fp)
        with get_connection() as conn:
            tag_cache = make_tag_cache(conn)
            for row in reader:
                print(row)
                feeds = feedparser.parse(row[1])
                for entry in feeds['entries']:
                    with conn.cursor() as cur:
                        cur.execute('SELECT id from cloudupdate.aws_blog_feed WHERE id = %s', (entry['id'],))
                        exists = cur.fetchall()
                        if (len(exists) == 0):
                            cur.execute('INSERT INTO cloudupdate.aws_blog_feed (id, title, link, summary, published, source) VALUES (%s, %s, %s, %s, %s, %s)', (entry['id'], entry['title'], entry['link'], entry['summary'][:1024], entry['published'], row[0]))
                            for tag in entry['tags']:
                                if (tag['term'] not in tag_cache):
                                    cur.execute('INSERT INTO cloudupdate.aws_blog_tag (name) VALUES (%s)', (tag['term'],))
                                    tag_cache = make_tag_cache(conn)
                                cur.execute('INSERT INTO cloudupdate.aws_blog_tagging (feed_id, tag_id) VALUES (%s, %s)', (entry['id'], tag_cache[tag['term']],))
                            conn.commit()

aws_blog_fetch_feed()
