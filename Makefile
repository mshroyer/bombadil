.PHONY : test tidy

test:
	prove pubdns/t/
	prove lib/Bombadil/t/

tidy:
	perltidy -ce -pt=2 -b **/*.pl
