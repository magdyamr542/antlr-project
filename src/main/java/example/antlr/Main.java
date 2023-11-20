package example.antlr;

import java.io.File;
import java.io.FileInputStream;

import org.antlr.runtime.ANTLRInputStream;
import org.antlr.runtime.CharStream;
import org.antlr.runtime.CommonTokenStream;

public class Main {
	public static void main(String[] args) throws Exception {

		if (args.length != 1) {
			System.out.println("Please provide the test file (that contains the game spec) as the first argument!!");
			System.exit(1);
		}

		String fileName = args[0];
		File file = new File(fileName);
		FileInputStream fis = null;

		try {
			fis = new FileInputStream(file);

			CharStream input = new ANTLRInputStream(fis);

			MGPLLexer lexer = new MGPLLexer(input);
			CommonTokenStream tokens = new CommonTokenStream(lexer);
			MGPLParser parser = new MGPLParser(tokens);
			parser.prog();

			fis.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
