Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:62500 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751659AbZBTCy1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 21:54:27 -0500
Message-ID: <499E1B61.20301@lwfinger.net> (sfid-20090220_035431_896289_C132BC1F)
Date: Thu, 19 Feb 2009 20:54:25 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] compat-2.6: Add place holder for CONFIG_MAC80211_DEBUGFS
 in config.mk
References: <499DA503.4070404@hauke-m.de> <43e72e890902191345r74688e72hb9181aa1e4ae25aa@mail.gmail.com>
In-Reply-To: <43e72e890902191345r74688e72hb9181aa1e4ae25aa@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is difficult to help someone debug a rate-setting problem when using
compat-wireless because debugging is not set for mac80211. With this patch
the place holder is in the make file even though the debug option is not
set, and it will be easier to coach a user on turning it on.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: compat-wireless-2009-02-19/config.mk
===================================================================
--- compat-wireless-2009-02-19.orig/config.mk
+++ compat-wireless-2009-02-19/config.mk
@@ -74,6 +74,7 @@ endif # kernel Makefile check

 # Wireless subsystem stuff
 CONFIG_MAC80211=m
+# CONFIG_MAC80211_DEBUGFS is not set

 # choose between pid and minstrel as default rate control algorithm
 CONFIG_MAC80211_RC_DEFAULT=minstrel

