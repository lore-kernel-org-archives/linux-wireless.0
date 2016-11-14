Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35634 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932515AbcKNQff (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 11:35:35 -0500
Received: by mail-lf0-f66.google.com with SMTP id p100so7513013lfg.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2016 08:35:34 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC 10/12] ath10k: Added QCA65XX hw definition
Date: Mon, 14 Nov 2016 17:33:40 +0100
Message-Id: <1479141222-8493-11-git-send-email-erik.stromdahl@gmail.com> (sfid-20161114_173600_017637_98571078)
In-Reply-To: <1479141222-8493-1-git-send-email-erik.stromdahl@gmail.com>
References: <1479141222-8493-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/hw.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 46142e9..ef45ecf 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -224,6 +224,7 @@ enum ath10k_hw_rev {
 	ATH10K_HW_QCA9377,
 	ATH10K_HW_QCA4019,
 	ATH10K_HW_QCA9887,
+	ATH10K_HW_QCA65XX,
 };
 
 struct ath10k_hw_regs {
-- 
1.7.9.5
