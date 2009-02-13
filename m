Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-156-71.gdrpmi.dsl-w.verizon.net ([71.115.156.71]:60110
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbZBMRlX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 12:41:23 -0500
Message-ID: <4995B0BE.6000502@erley.org> (sfid-20090213_184127_068434_A64D6497)
Date: Fri, 13 Feb 2009 12:41:18 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [patch] compat-wireless compat.diff update for latest wireless-testing
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wireless testing now includes scan.o, patch needs to reflect that.

Signed-off-by: Pat Erley <pat-lkml@erley.org>
---

Diffs of diffs look funny, haha

diff --git a/compat/compat.diff b/compat/compat.diff
index 4d96eec..ff4d157 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -18,8 +18,8 @@
  obj-$(CONFIG_LIB80211_CRYPT_CCMP) += lib80211_crypt_ccmp.o
  obj-$(CONFIG_LIB80211_CRYPT_TKIP) += lib80211_crypt_tkip.o
  
--cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o
-+cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o compat.o
+-cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o
++cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o compat.o
  cfg80211-$(CONFIG_WIRELESS_EXT) += wext-compat.o
  cfg80211-$(CONFIG_NL80211) += nl80211.o
 --- a/drivers/net/wireless/zd1211rw/zd_chip.h  2008-03-07 20:02:06.000000000 -0500
