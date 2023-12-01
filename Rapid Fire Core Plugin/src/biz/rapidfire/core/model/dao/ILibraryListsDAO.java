/*******************************************************************************
 * Copyright (c) 2017-2017 Rapid Fire Project Team
 * All rights reserved. This program and the accompanying materials 
 * are made available under the terms of the Common Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/cpl-v10.html
 *******************************************************************************/

package biz.rapidfire.core.model.dao;

import java.util.List;

import org.eclipse.swt.widgets.Shell;

import biz.rapidfire.core.model.IRapidFireJobResource;
import biz.rapidfire.core.model.IRapidFireLibraryListResource;

public interface ILibraryListsDAO {

    public List<IRapidFireLibraryListResource> load(IRapidFireJobResource job, Shell shell) throws Exception;

    public IRapidFireLibraryListResource load(IRapidFireJobResource job, String libraryListName, Shell shell) throws Exception;
}
