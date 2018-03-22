Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:52652 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751901AbeCVU2i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Mar 2018 16:28:38 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V2 12/12] brcmfmac: add kerneldoc for struct brcmf_bus::msgbuf
Date: Thu, 22 Mar 2018 21:28:31 +0100
Message-Id: <1521750511-12345-13-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180322_212903_990428_ACF0548F)
In-Reply-To: <1521750511-12345-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1521750511-12345-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This field did not have kerneldoc description so adding it now.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
index 31858a2..27e693e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -140,6 +140,7 @@ struct brcmf_bus_stats {
  * @always_use_fws_queue: bus wants use queue also when fwsignal is inactive.
  * @wowl_supported: is wowl supported by bus driver.
  * @chiprev: revision of the dongle chip.
+ * @msgbuf: msgbuf protocol parameters provided by bus layer.
  */
 struct brcmf_bus {
 	union {
-- 
1.9.1
