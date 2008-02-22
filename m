Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:7288 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbYBVFBH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 00:01:07 -0500
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 5/5] at76_usb: make the driver depend on MAC80211
To: linux-wireless@vger.kernel.org, at76c503a-develop@lists.berlios.de
Date: Fri, 22 Feb 2008 00:01:07 -0500
Message-ID: <20080222050107.11158.49112.stgit@dv.roinet.com> (sfid-20080222_050115_004405_72A6450C)
In-Reply-To: <20080222050044.11158.86655.stgit@dv.roinet.com>
References: <20080222050044.11158.86655.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 8f935e0..8d368b4 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -459,7 +459,7 @@ config PCMCIA_ATMEL
 
 config USB_ATMEL
 	tristate "Atmel at76c503/at76c505/at76c505a USB cards"
-	depends on WLAN_80211 && USB
+	depends on MAC80211 && WLAN_80211 && USB
 	select FW_LOADER
 	---help---
 	  Enable support for USB Wireless devices using Atmel at76c503,
