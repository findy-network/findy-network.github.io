comments:
	@./gh-comments-all.sh

run:
	@hugo server --bind=0.0.0.0 --baseURL=http://0.0.0.0:1313

release:
	gh workflow run do-release.yml
