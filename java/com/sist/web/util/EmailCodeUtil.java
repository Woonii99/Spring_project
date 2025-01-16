package com.sist.web.util;

import java.util.concurrent.ConcurrentHashMap;

public class EmailCodeUtil 
{
	private static final ConcurrentHashMap<String, String> store = new ConcurrentHashMap<>();

    public static void storeCode(String email, String code)
    {
        store.put(email, code);
    }

    public static String getCode(String code)
    {
        return store.get(code);
    }

    public static void clearCode(String code)
    {
        store.remove(code);
    }
}
