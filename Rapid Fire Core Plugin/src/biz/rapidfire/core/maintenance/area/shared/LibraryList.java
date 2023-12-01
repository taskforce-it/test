/*******************************************************************************
 * Copyright (c) 2017-2017 Rapid Fire Project Owners
 * All rights reserved. This program and the accompanying materials 
 * are made available under the terms of the Common Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/cpl-v10.html
 *******************************************************************************/

package biz.rapidfire.core.maintenance.area.shared;

import java.util.HashMap;
import java.util.Map;

public enum LibraryList {
    NONE ("*NONE"); //$NON-NLS-1$

    private String label;

    private static Map<String, LibraryList> copyPrograms;

    static {
        copyPrograms = new HashMap<String, LibraryList>();
        for (LibraryList status : LibraryList.values()) {
            copyPrograms.put(status.label, status);
        }
    }

    private LibraryList(String label) {
        this.label = label;
    }

    public String label() {
        return label;
    }

    public static String[] labels() {
        return copyPrograms.keySet().toArray(new String[copyPrograms.size()]);
    }

    public static LibraryList find(String label) {
        // TODO: remove debug code
        if (label.length() != label.trim().length()) {
            throw new IllegalArgumentException("Expect to see a trimmed value here."); //$NON-NLS-1$
        }
        return copyPrograms.get(label);
    }

}
