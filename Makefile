all:
	elm make src/Main.elm --output=src/elm.js

clean:
	rm -r dist

build:
	mkdir -p dist
	cp -r src/css dist/
	cp src/index.html dist
	elm make --optimize src/Main.elm --output dist/elm.js

deploy: clean build
	cd dist && now --public

deploy-server:
	cd server && now --public
