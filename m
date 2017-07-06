Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35905 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751828AbdGFOnL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 10:43:11 -0400
Received: by mail-pf0-f195.google.com with SMTP id z6so555545pfk.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jul 2017 07:43:11 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Subject: [v3 17/21] rsi: rename variable in_sdio_litefi_irq
Date: Thu,  6 Jul 2017 20:07:20 +0530
Message-Id: <1499351844-2046-18-git-send-email-amitkarwar@gmail.com> (sfid-20170706_170042_646029_FFA4AF47)
In-Reply-To: <1499351844-2046-1-git-send-email-amitkarwar@gmail.com>
References: <1499351844-2046-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karun Eagalapati <karun256@gmail.com>

The variable in_sdio_litefi_irq is renamed to sdio_irq_task,
as it is more relevant here.

Signed-off-by: Karun Eagalapati <karun256@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_sdio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
index f11f818..cbbc0448 100644
--- a/drivers/net/wireless/rsi/rsi_sdio.h
+++ b/drivers/net/wireless/rsi/rsi_sdio.h
@@ -104,7 +104,7 @@ struct receive_info {
 
 struct rsi_91x_sdiodev {
 	struct sdio_func *pfunction;
-	struct task_struct *in_sdio_litefi_irq;
+	struct task_struct *sdio_irq_task;
 	struct receive_info rx_info;
 	u32 next_read_delay;
 	u32 sdio_high_speed_enable;
-- 
2.7.4
