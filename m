Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:33508 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464Ab2B2RSm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 12:18:42 -0500
Subject: [PATCH 01/12] ath6kl: fix pointer style
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Wed, 29 Feb 2012 19:18:30 +0200
Message-ID: <20120229171830.24264.51379.stgit@localhost6.localdomain6> (sfid-20120229_181845_559929_1B4B0280)
In-Reply-To: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
References: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reported by checkpatch:

ath6kl/core.h:748: ERROR: "foo * bar" should be "foo *bar"
ath6kl/core.h:751: ERROR: "foo * bar" should be "foo *bar"

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 5bbc595..d80b421 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -745,10 +745,10 @@ struct htc_packet *ath6kl_alloc_amsdu_rxbuf(struct htc_target *target,
 void aggr_module_destroy(struct aggr_info *aggr_info);
 void aggr_reset_state(struct aggr_info_conn *aggr_conn);
 
-struct ath6kl_sta *ath6kl_find_sta(struct ath6kl_vif *vif, u8 * node_addr);
+struct ath6kl_sta *ath6kl_find_sta(struct ath6kl_vif *vif, u8 *node_addr);
 struct ath6kl_sta *ath6kl_find_sta_by_aid(struct ath6kl *ar, u8 aid);
 
-void ath6kl_ready_event(void *devt, u8 * datap, u32 sw_ver, u32 abi_ver);
+void ath6kl_ready_event(void *devt, u8 *datap, u32 sw_ver, u32 abi_ver);
 int ath6kl_control_tx(void *devt, struct sk_buff *skb,
 		      enum htc_endpoint_id eid);
 void ath6kl_connect_event(struct ath6kl_vif *vif, u16 channel,

