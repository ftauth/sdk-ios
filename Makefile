OUTPUT := FTAuthInternal.framework

.PHONY: build
build: clean
	GOPRIVATE=github.com/ftauth gomobile bind -target ios -o $(OUTPUT) -v github.com/ftauth/sdk-mobile

.PHONY: test
test:
	echo "Testing..."

.PHONY: clean
clean:
	rm -rf $(OUTPUT)