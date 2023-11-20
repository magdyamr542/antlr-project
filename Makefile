grammar:
	./gradlew generateGrammarSource

build:
	./gradlew build

run:
	./gradlew run

install-gui:
	wget https://www.antlr3.org/download/antlrworks-1.5.1.jar

run-gui:
	java -jar antlrworks-1.5.1.jar 

