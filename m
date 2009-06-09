Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58230 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZFIN5Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 09:57:24 -0400
Subject: [PATCH] rfkill: include err.h
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 09 Jun 2009 15:56:52 +0200
Message-Id: <1244555812.4672.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we use ERR_PTR and similar macros, we need to include linux/err.h.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/rfkill.h |    1 +
 1 file changed, 1 insertion(+)

--- wireless-testing.orig/include/linux/rfkill.h	2009-06-09 15:55:06.000000000 +0200
+++ wireless-testing/include/linux/rfkill.h	2009-06-09 15:55:20.000000000 +0200
@@ -105,6 +105,7 @@ enum rfkill_user_states {
 #include <linux/mutex.h>
 #include <linux/device.h>
 #include <linux/leds.h>
+#include <linux/err.h>
 
 /* this is opaque */
 struct rfkill;


