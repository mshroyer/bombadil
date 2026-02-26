.PHONY : test tidy

test:
	prove pubdns/t/

tidy:
	perltidy -ce -pt=2 -b **/*.pl
