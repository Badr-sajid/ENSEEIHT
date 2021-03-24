package allumettes;

public class OperationInterditeException extends RuntimeException {

	// pour détécter la triche
	public OperationInterditeException(String message) {
		super(message);
	}
}
