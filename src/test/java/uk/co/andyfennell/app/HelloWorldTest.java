package uk.co.andyfennell.app;

import static org.junit.Assert.*;

import org.junit.Test;

public class HelloWorldTest {

	@Test
	public void testShouldPass() {
		HelloWorld hello = new HelloWorld();
		assertEquals(hello.sayHelloWorld(), "Hello world");
	}

/**
	@Test
	public void testShouldFail() {
		HelloWorld hello = new HelloWorld();
		assertEquals(hello.sayHelloWorld(), "Goodbye");
	}
*/

}
