
pretty: check_swiftformat_installed
	swiftformat . --config airbnb.swiftformat


check_swiftformat_installed:
	@which swiftformat > /dev/null || (echo "Please install swiftformat: brew install swiftformat" && exit 1)
