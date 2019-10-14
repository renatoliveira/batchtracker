public class bat_IDGenerator {
	private static Integer fakeIdCount = 0;
	private static final String ID_PATTERN = '000000000000';

    public static Id generate(SObjectType sot) {
        return generate(sot.getDescribe().getKeyPrefix());
    }

    public static Id generate(String keyPrefix) {
        return generate(keyPrefix, fakeIdCount);
    }

	public static Id generate(String keyPrefix, Decimal n) {
        String fakeIdPrefix = '000000000000'.substring(0, 12 - n.precision());
        fakeIdCount++;
        return Id.valueOf(keyPrefix + fakeIdPrefix + n);
    }
}