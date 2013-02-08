Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:63327 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947074Ab3BHUcx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 15:32:53 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH 14/14] cw1200: v4:  Add to drivers/net/wireless kbuild, plus MAINTAINERS entry.
Date: Fri,  8 Feb 2013 15:32:07 -0500
Message-Id: <1360355527-12159-15-git-send-email-pizza@shaftnet.org> (sfid-20130208_215345_347999_1D233A54)
In-Reply-To: <1360355527-12159-1-git-send-email-pizza@shaftnet.org>
References: <1360355527-12159-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 MAINTAINERS                   | 5 +++++
 drivers/net/wireless/Kconfig  | 1 +
 drivers/net/wireless/Makefile | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 35a56bc..03f73dd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2187,6 +2187,11 @@ M:	Jaya Kumar <jayakumar.alsa@gmail.com>
 S:	Maintained
 F:	sound/pci/cs5535audio/
 
+CW1200 WLAN driver
+M:     Solomon Peachy <pizza@shaftnet.org>
+S:     Maintained
+F:     drivers/net/wireless/cw1200/
+
 CX18 VIDEO4LINUX DRIVER
 M:	Andy Walls <awalls@md.metrocast.net>
 L:	ivtv-devel@ivtvdriver.org (moderated for non-subscribers)
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 28aa05f..fe1090b 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -280,5 +280,6 @@ source "drivers/net/wireless/rtlwifi/Kconfig"
 source "drivers/net/wireless/ti/Kconfig"
 source "drivers/net/wireless/zd1211rw/Kconfig"
 source "drivers/net/wireless/mwifiex/Kconfig"
+source "drivers/net/wireless/cw1200/Kconfig"
 
 endif # WLAN
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 67156ef..5c7b6f6 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -57,3 +57,6 @@ obj-$(CONFIG_MWIFIEX)	+= mwifiex/
 
 obj-$(CONFIG_BRCMFMAC)	+= brcm80211/
 obj-$(CONFIG_BRCMSMAC)	+= brcm80211/
+
+obj-$(CONFIG_CW1200)    += cw1200/
+
-- 
1.8.1.2

