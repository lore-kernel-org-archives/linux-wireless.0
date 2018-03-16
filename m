Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:46116 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753164AbeCPKMK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 06:12:10 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 12/12] brcmfmac: add kerneldoc for struct brcmf_bus::msgbuf
Date: Fri, 16 Mar 2018 11:11:25 +0100
Message-Id: <1521195085-439-13-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180316_111229_268036_0831B899)
In-Reply-To: <1521195085-439-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1521195085-439-1-git-send-email-arend.vanspriel@broadcom.com>
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
