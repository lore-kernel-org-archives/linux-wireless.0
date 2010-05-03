Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:1586 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754897Ab0ECUnT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 16:43:19 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 2/4] rt2x00: Enable RT30xx by default.
Date: Mon,  3 May 2010 22:43:03 +0200
Message-Id: <1272919385-18004-3-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1272919385-18004-1-git-send-email-gwingerde@gmail.com>
References: <1272919385-18004-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that RT30xx support is at the same level as RT28xx support we can enable
these devices by default.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index 5239e08..eea1ef2 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -87,7 +87,7 @@ if RT2800PCI
 
 config RT2800PCI_RT30XX
 	bool "rt2800pci - Include support for rt30xx (PCI/PCIe/PCMCIA) devices"
-	default n
+	default y
 	---help---
 	  This adds support for rt30xx wireless chipset family to the
 	  rt2800pci driver.
@@ -156,7 +156,7 @@ if RT2800USB
 
 config RT2800USB_RT30XX
 	bool "rt2800usb - Include support for rt30xx (USB) devices"
-	default n
+	default y
 	---help---
 	  This adds support for rt30xx wireless chipset family to the
 	  rt2800usb driver.
-- 
1.7.1

