GRADLE_RUN_CMD = ./gradlew run --warning-mode none

grammar:
	./gradlew generateGrammarSource

build:
	./gradlew build

test-invaders:
	$(GRADLE_RUN_CMD) --args ./resources/Invaders.mgpl

test-pong:
	$(GRADLE_RUN_CMD) --args ./resources/Pong.mgpl


install-gui:
	wget https://www.antlr3.org/download/antlrworks-1.5.1.jar

run-gui:
	java -jar antlrworks-1.5.1.jar 

