package uk.co.andyfennell.app;

public class HelloWorld {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		// little change
		// remote change
		// another remote change
		HelloWorld hello = new HelloWorld();

		System.out.println(hello.sayHelloWorld());
	}

	public String sayHelloWorld() {
		return getMessage();
	}

	private static String getMessage() {
		return "Hello world";
	}

}
