Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33241 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933084AbdCWK3k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Mar 2017 06:29:40 -0400
Received: by mail-lf0-f68.google.com with SMTP id r36so16367092lfi.0
        for <linux-wireless@vger.kernel.org>; Thu, 23 Mar 2017 03:29:39 -0700 (PDT)
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
Subject: [PATCH V2] brcmfmac: update BRCMFMAC symbol description
Date: Thu, 23 Mar 2017 11:29:28 +0100
Message-Id: <20170323102928.11413-1-zajec5@gmail.com> (sfid-20170323_113005_677707_C31C5A96)
In-Reply-To: <20170321144339.1709-1-zajec5@gmail.com>
References: <20170321144339.1709-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

For quite some time now brcmfmac supports 802.11ac chipsets and it's
not limited to embedded devices only. There are even standalone PCIe
cards based on BCM43602 or BCM4366.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
V2: Drop "IEEE802.11n" part instead of "FullMAC" part, thanks Arend
---
 drivers/net/wireless/broadcom/brcm80211/Kconfig | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/Kconfig b/drivers/net/wireless/broadcom/brcm80211/Kconfig
index d93561f6ef97..4e5df0e15197 100644
--- a/drivers/net/wireless/broadcom/brcm80211/Kconfig
+++ b/drivers/net/wireless/broadcom/brcm80211/Kconfig
@@ -18,14 +18,14 @@ config BRCMSMAC
 	  module, the driver will be called brcmsmac.ko.
 
 config BRCMFMAC
-	tristate "Broadcom IEEE802.11n embedded FullMAC WLAN driver"
+	tristate "Broadcom FullMAC WLAN driver"
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
