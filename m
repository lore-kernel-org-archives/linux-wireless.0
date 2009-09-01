Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:33693 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbZIAMdJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 08:33:09 -0400
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 4/4] rndis_wlan: remove 'select WIRELESS_EXT' in Kconfig
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 01 Sep 2009 15:33:11 +0300
Message-ID: <20090901123311.9213.65635.stgit@fate.lan>
In-Reply-To: <20090901123255.9213.57970.stgit@fate.lan>
References: <20090901123255.9213.57970.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since rndis_wlan is now converted to cfg80211, WIRELESS_EXT isn't
required anymore.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/wireless/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index dda7cc2..623897f 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -337,7 +337,6 @@ config USB_NET_RNDIS_WLAN
 	select USB_USBNET
 	select USB_NET_CDCETHER
 	select USB_NET_RNDIS_HOST
-	select WIRELESS_EXT
 	---help---
 	  This is a driver for wireless RNDIS devices.
 	  These are USB based adapters found in devices such as:

