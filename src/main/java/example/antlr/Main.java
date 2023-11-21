package example.antlr;

import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;

import org.antlr.runtime.ANTLRInputStream;
import org.antlr.runtime.CharStream;
import org.antlr.runtime.CommonTokenStream;
import org.antlr.runtime.tree.CommonTree;

public class Main {
	public static void main(String[] args) throws Exception {
		boolean containsAst = false;
		ArrayList<String> newArgs = new ArrayList<String>();
		for (String arg : args) {
			if (arg.equals("--ast") || arg.equals("-ast")) {
				containsAst = true;
				continue;
			}
			newArgs.add(arg);
		}

		args = new String[newArgs.size()];
		args = newArgs.toArray(args);

		if (args.length != 1) {
			System.out.println("Please provide the test file (that contains the game spec)!!");
			System.exit(1);
		}

		if (containsAst) {
			mainAst(args);
			return;
		}

		mainNormal(args);

	}

	public static void mainNormal(String[] args) throws Exception {
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

	public static void mainAst(String[] args) throws Exception {

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
			System.out.println(tree.toStringTree());

			fis.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
