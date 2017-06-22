Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:41332 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753022AbdFVKBJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 06:01:09 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 1/4] brcmfmac: cleanup kerneldoc for struct brcmf_bus
Date: Thu, 22 Jun 2017 11:01:01 +0100
Message-Id: <1498125664-25980-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170622_120117_419057_26ADA94E)
In-Reply-To: <1498125664-25980-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1498125664-25980-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A couple of old fields were still described and one field was not
described.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
index b55c329..e2c895b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -122,9 +122,8 @@ struct brcmf_bus_msgbuf {
  * @state: operational state of the bus interface.
  * @maxctl: maximum size for rxctl request message.
  * @tx_realloc: number of tx packets realloced for headroom.
- * @dstats: dongle-based statistical data.
- * @dcmd_list: bus/device specific dongle initialization commands.
  * @chip: device identifier of the dongle chip.
+ * @always_use_fws_queue: bus wants use queue also when fwsignal is inactive.
  * @wowl_supported: is wowl supported by bus driver.
  * @chiprev: revision of the dongle chip.
  */
-- 
1.9.1
