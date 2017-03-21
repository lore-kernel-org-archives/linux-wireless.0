Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:36588 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757263AbdCUOny (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Mar 2017 10:43:54 -0400
Received: by mail-lf0-f67.google.com with SMTP id g70so13199608lfh.3
        for <linux-wireless@vger.kernel.org>; Tue, 21 Mar 2017 07:43:53 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH] brcmfmac: update BRCMFMAC symbol description
Date: Tue, 21 Mar 2017 15:43:39 +0100
Message-Id: <20170321144339.1709-1-zajec5@gmail.com> (sfid-20170321_154418_615861_69281E6D)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

For quite some time now brcmfmac supports 802.11ac chipsets and it's
not limited to embedded devices only. There are even standalone PCIe
cards based on BCM43602 or BCM4366.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/wireless/broadcom/brcm80211/Kconfig | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/Kconfig b/drivers/net/wireless/broadcom/brcm80211/Kconfig
index d93561f6ef97..817cb28f518f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/Kconfig
+++ b/drivers/net/wireless/broadcom/brcm80211/Kconfig
@@ -18,14 +18,14 @@ config BRCMSMAC
 	  module, the driver will be called brcmsmac.ko.
 
 config BRCMFMAC
-	tristate "Broadcom IEEE802.11n embedded FullMAC WLAN driver"
+	tristate "Broadcom IEEE802.11n WLAN driver"
 	depends on CFG80211
 	select BRCMUTIL
 	---help---
-	  This module adds support for embedded wireless adapters based on
-	  Broadcom IEEE802.11n FullMAC chipsets. It has to work with at least
-	  one of the bus interface support. If you choose to build a module,
-	  it'll be called brcmfmac.ko.
+	  This module adds support for wireless adapters based on Broadcom
+	  FullMAC chipsets. It has to work with at least one of the bus
+	  interface support. If you choose to build a module, it'll be called
+	  brcmfmac.ko.
 
 config BRCMFMAC_PROTO_BCDC
 	bool
-- 
2.11.0
