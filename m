Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:52778 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751229Ab1LSOcH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 09:32:07 -0500
Received: by lahl5 with SMTP id l5so4058390lah.27
        for <linux-wireless@vger.kernel.org>; Mon, 19 Dec 2011 06:32:04 -0800 (PST)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH] wl12xx: add missing copyright notice
Date: Mon, 19 Dec 2011 16:31:55 +0200
Message-Id: <1324305115-14963-1-git-send-email-coelho@ti.com> (sfid-20111219_153211_798740_C7BB91B3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wl12xx_platform_data.c file did not have a proper copyright
notice.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/wl12xx_platform_data.c |   21 ++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl12xx_platform_data.c b/drivers/net/wireless/wl12xx/wl12xx_platform_data.c
index 3c96b33..998e958 100644
--- a/drivers/net/wireless/wl12xx/wl12xx_platform_data.c
+++ b/drivers/net/wireless/wl12xx/wl12xx_platform_data.c
@@ -1,3 +1,24 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 2010-2011 Texas Instruments, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
 #include <linux/module.h>
 #include <linux/err.h>
 #include <linux/wl12xx.h>
-- 
1.7.4.1

