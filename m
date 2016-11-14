Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33080 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932951AbcKNQfb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 11:35:31 -0500
Received: by mail-lf0-f68.google.com with SMTP id 98so7490822lfs.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2016 08:35:30 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC 05/12] ath10k: htc: Added ATH10K_HTC_FLAG_BUNDLE_LSB
Date: Mon, 14 Nov 2016 17:33:35 +0100
Message-Id: <1479141222-8493-6-git-send-email-erik.stromdahl@gmail.com> (sfid-20161114_173622_090194_9EC8DB56)
In-Reply-To: <1479141222-8493-1-git-send-email-erik.stromdahl@gmail.com>
References: <1479141222-8493-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htc.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless/ath/ath10k/htc.h
index 589800a..df16a04 100644
--- a/drivers/net/wireless/ath/ath10k/htc.h
+++ b/drivers/net/wireless/ath/ath10k/htc.h
@@ -62,6 +62,8 @@ enum ath10k_htc_rx_flags {
 	ATH10K_HTC_FLAG_BUNDLE_MASK     = 0xF0
 };
 
+#define ATH10K_HTC_FLAG_BUNDLE_LSB         4
+
 struct ath10k_htc_hdr {
 	u8 eid; /* @enum ath10k_htc_ep_id */
 	u8 flags; /* @enum ath10k_htc_tx_flags, ath10k_htc_rx_flags */
-- 
1.7.9.5
