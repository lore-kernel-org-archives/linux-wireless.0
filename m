Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:33923 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063AbZJAJvY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2009 05:51:24 -0400
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id n919ngob011355
	for <linux-wireless@vger.kernel.org>; Thu, 1 Oct 2009 04:50:35 -0500
Received: from [127.0.1.1] (essapo-nirac253112.europe.nokia.com [10.162.253.112])
	by mgw-da01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id n919pLef023627
	for <linux-wireless@vger.kernel.org>; Thu, 1 Oct 2009 12:51:22 +0300
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH] wl1251: remove wl1251_netlink.h
To: linux-wireless@vger.kernel.org
Date: Thu, 01 Oct 2009 12:51:20 +0300
Message-ID: <20091001095119.14320.61001.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

The file was accidentally added in commit ef2f8d4577 ("wl1251: add
wl1251 prefix to all 1251 files"). This happened when I rebased the
patches from a private tree.

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_netlink.h |   30 --------------------------
 1 files changed, 0 insertions(+), 30 deletions(-)
 delete mode 100644 drivers/net/wireless/wl12xx/wl1251_netlink.h

diff --git a/drivers/net/wireless/wl12xx/wl1251_netlink.h b/drivers/net/wireless/wl12xx/wl1251_netlink.h
deleted file mode 100644
index ee36695..0000000
--- a/drivers/net/wireless/wl12xx/wl1251_netlink.h
+++ /dev/null
@@ -1,30 +0,0 @@
-/*
- * This file is part of wl1251
- *
- * Copyright (C) 2009 Nokia Corporation
- *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#ifndef __WL1251_NETLINK_H__
-#define __WL1251_NETLINK_H__
-
-int wl1251_nl_register(void);
-void wl1251_nl_unregister(void);
-
-#endif /* __WL1251_NETLINK_H__ */

