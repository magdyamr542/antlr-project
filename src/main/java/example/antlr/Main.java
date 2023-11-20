package example.antlr;

import org.antlr.runtime.ANTLRStringStream;
import org.antlr.runtime.CommonTokenStream;

public class Main {
	public static void main(String[] args) throws Exception {
		ANTLRStringStream in = new ANTLRStringStream("12*(5-6)");
		MGPLLexer lexer = new MGPLLexer(in);
		CommonTokenStream tokens = new CommonTokenStream(lexer);
		MGPLParser parser = new MGPLParser(tokens);
	}
}
