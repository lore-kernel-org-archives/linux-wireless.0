Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58478 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab1AJHML (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 02:12:11 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH RESEND 04/11] ath9k:  Remove un-used member from ath_node.
Date: Sun,  9 Jan 2011 23:11:46 -0800
Message-Id: <1294643513-18820-5-git-send-email-greearb@candelatech.com>
In-Reply-To: <1294643513-18820-1-git-send-email-greearb@candelatech.com>
References: <1294643513-18820-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 3681caf5.. deda815... M	drivers/net/wireless/ath/ath9k/ath9k.h
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 3681caf5..deda815 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -342,7 +342,6 @@ struct ath_vif {
 	__le64 tsf_adjust; /* TSF adjustment for staggered beacons */
 	enum nl80211_iftype av_opmode;
 	struct ath_buf *av_bcbuf;
-	struct ath_tx_control av_btxctl;
 	u8 bssid[ETH_ALEN]; /* current BSSID from config_interface */
 };
 
-- 
1.7.2.3

