Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4056 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760308Ab3DCKlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 06:41:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 21/25] brcmfmac: correct specified length from
 FIFOCREDITBACK signal
Date: Wed, 3 Apr 2013 12:40:46 +0200
Message-ID: <1364985650-11719-22-git-send-email-arend@broadcom.com> (sfid-20130403_124305_983883_0B9068E3)
In-Reply-To: <1364985650-11719-1-git-send-email-arend@broadcom.com>
References: <1364985650-11719-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The length is not according specification so better fix it.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 6d036b7..6da9f82 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -59,7 +59,7 @@
 	BRCMF_FWS_TLV_DEF(RSSI, 8, 1) \
 	BRCMF_FWS_TLV_DEF(INTERFACE_OPEN, 9, 1) \
 	BRCMF_FWS_TLV_DEF(INTERFACE_CLOSE, 10, 1) \
-	BRCMF_FWS_TLV_DEF(FIFO_CREDITBACK, 11, 8) \
+	BRCMF_FWS_TLV_DEF(FIFO_CREDITBACK, 11, 6) \
 	BRCMF_FWS_TLV_DEF(PENDING_TRAFFIC_BMP, 12, 2) \
 	BRCMF_FWS_TLV_DEF(MAC_REQUEST_PACKET, 13, 3) \
 	BRCMF_FWS_TLV_DEF(HOST_REORDER_RXPKTS, 14, 10) \
-- 
1.7.10.4


