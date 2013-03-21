Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:51884 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334Ab3CUWko (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Mar 2013 18:40:44 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH 15/15] cw1200: v5: Add MAINTAINERS entry and add to drivers/net/wireless build
Date: Thu, 21 Mar 2013 18:39:49 -0400
Message-Id: <1363905589-8350-16-git-send-email-pizza@shaftnet.org> (sfid-20130321_234303_682124_82DC2FC4)
In-Reply-To: <1363905589-8350-1-git-send-email-pizza@shaftnet.org>
References: <1363905589-8350-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 MAINTAINERS                   | 5 +++++
 drivers/net/wireless/Kconfig  | 1 +
 drivers/net/wireless/Makefile | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ce424d7..bfe91c7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2260,6 +2260,11 @@ M:	Jaya Kumar <jayakumar.alsa@gmail.com>
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
index f8f0156..200020e 100644
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
1.8.1.4

