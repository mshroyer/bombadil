.PHONY : tidy

tidy:
	perltidy -ce -pt=2 -b **/*.pl
