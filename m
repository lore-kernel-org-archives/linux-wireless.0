Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36616 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932462AbcKNQfc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 11:35:32 -0500
Received: by mail-lf0-f68.google.com with SMTP id o20so7510713lfg.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2016 08:35:31 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC 07/12] ath10k: Added SDIO dbg masks
Date: Mon, 14 Nov 2016 17:33:37 +0100
Message-Id: <1479141222-8493-8-git-send-email-erik.stromdahl@gmail.com> (sfid-20161114_173603_137662_8A251D39)
In-Reply-To: <1479141222-8493-1-git-send-email-erik.stromdahl@gmail.com>
References: <1479141222-8493-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Debug masks for SDIO HIF layer.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/debug.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 335512b..d35263c 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -38,6 +38,8 @@ enum ath10k_debug_mask {
 	ATH10K_DBG_WMI_PRINT	= 0x00002000,
 	ATH10K_DBG_PCI_PS	= 0x00004000,
 	ATH10K_DBG_AHB		= 0x00008000,
+	ATH10K_DBG_SDIO		= 0x00010000,
+	ATH10K_DBG_SDIO_DUMP	= 0x00020000,
 	ATH10K_DBG_ANY		= 0xffffffff,
 };
 
-- 
1.7.9.5
