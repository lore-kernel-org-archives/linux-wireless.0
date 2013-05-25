Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rrcs-24-73-230-86.se.biz.rr.com ([24.73.230.86]:39112 "EHLO
	stuffed.shaftnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab3EYAE6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 May 2013 20:04:58 -0400
Received: from stuffed.shaftnet.org (localhost [127.0.0.1])
	by stuffed.shaftnet.org (8.14.5/8.14.5) with ESMTP id r4P04vbw009476
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 24 May 2013 20:04:57 -0400
Received: (from pizza@localhost)
	by stuffed.shaftnet.org (8.14.5/8.14.5/Submit) id r4P04v3K009475
	for linux-wireless@vger.kernel.org; Fri, 24 May 2013 20:04:57 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ST-E CW1200 driver (v7)
Date: Fri, 24 May 2013 20:04:37 -0400
Message-Id: <1369440291-8961-1-git-send-email-pizza@shaftnet.org> (sfid-20130525_020501_622790_8744952E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Very little has changed since the last patch:

 * Add a module paramater that disables bss loss mitigation entirely
 * 3.9 compatibility
 * Fix Kconfig (again)
 * 3.10 compatibility
 * Rebase against wireless-next 

The 3.10+ changes have been compile-tested only -- Due to a move-in-
progress I'm temporarily unable to test anything.

 - Solomon

