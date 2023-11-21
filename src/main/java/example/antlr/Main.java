package example.antlr;

import java.io.File;
import java.io.FileInputStream;

import org.antlr.runtime.ANTLRInputStream;
import org.antlr.runtime.CharStream;
import org.antlr.runtime.CommonTokenStream;
import org.antlr.runtime.tree.CommonTree;

public class Main {
	public static void main(String[] args) throws Exception {
		if (true) {
			main2(args);
			return;
		}

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

	public static void main2(String[] args) throws Exception {

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

			MGPL_ASTLexer lexer = new MGPL_ASTLexer(input);
			CommonTokenStream tokens = new CommonTokenStream(lexer);
			MGPL_ASTParser parser = new MGPL_ASTParser(tokens);
			CommonTree tree = (CommonTree) parser.prog().getTree();

			fis.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
