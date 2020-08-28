#include <stdio.h>
#include <string.h>
#include <string>
#include <iostream>
#include <cctype>

int main (int argc, char* argv[]) {
	if (argc < 1) {
		printf("asc2uni v1.00 - BPanther\n");
		printf("Syntax: asc2uni <string>\n");
		return 1;
	}
	std::string test = argv[1];
	for (std::size_t n = 0; n < test.length(); ++n) {
		std::cout << (unsigned char) test[n];
		std::cout << (unsigned char) '\0';
	}
	return 0;
}
