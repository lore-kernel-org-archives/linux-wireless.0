Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57744 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752215AbeGDJMx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 05:12:53 -0400
Subject: [PATCH] ath10k: fix open brace location in
 ath10k_wmi_tlv_op_gen_dbglog_cfg()
From: Kalle Valo <kvalo@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 04 Jul 2018 12:12:49 +0300
Message-ID: <153069556911.18112.15554530524319470412.stgit@potku.adurom.net> (sfid-20180704_111258_058713_D0416EB5)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes a recently added checkpatch warning:

wmi-tlv.c:2703: open brace '{' following function definitions go on the next line

Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index b04f86f8038a..435295dfe0d4 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2702,7 +2702,8 @@ ath10k_wmi_tlv_op_gen_force_fw_hang(struct ath10k *ar,
 
 static struct sk_buff *
 ath10k_wmi_tlv_op_gen_dbglog_cfg(struct ath10k *ar, u64 module_enable,
-				 u32 log_level) {
+				 u32 log_level)
+{
 	struct wmi_tlv_dbglog_cmd *cmd;
 	struct wmi_tlv *tlv;
 	struct sk_buff *skb;
