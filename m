Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54934 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab1A1TuR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 14:50:17 -0500
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]drivers:wireless:acx.h change initate to initiate
Date: Fri, 28 Jan 2011 11:50:04 -0800
Message-Id: <1296244204-3890-1-git-send-email-justinmattock@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not sure if this is a typo or not. if it is then feel free to take this.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/wireless/wl12xx/acx.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index 7bd8e4d..c56088b 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -987,7 +987,7 @@ struct wl1271_acx_ht_capabilities {
 	 *         Note, driver will still leave space for HT control in packets
 	 *         regardless of the value of this field. FW will be responsible
 	 *         to drop the HT field from any frame when this Bit set to 0.
-	 * bit 5 - Allow RD initiation in TXOP. FW is allowed to initate RD.
+	 * bit 5 - Allow RD initiation in TXOP. FW is allowed to initiate RD.
 	 *         Exact policy setting for this feature is TBD.
 	 *         Note, this bit can only be set to 1 if bit 3 is set to 1.
 	 */
-- 
1.6.5.GIT

