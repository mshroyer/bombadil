.PHONY : test tidy

test:
	prove pubdns/t/
	prove lib/Bombadil/t/

tidy:
	perltidy -pt=0 -b **/*.pl
