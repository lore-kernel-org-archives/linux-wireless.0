Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34877 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752961AbdFPO6Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 10:58:25 -0400
Received: by mail-pf0-f195.google.com with SMTP id s66so6916673pfs.2
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jun 2017 07:58:25 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v2 16/20] rsi: rename variable in_sdio_litefi_irq
Date: Fri, 16 Jun 2017 20:24:37 +0530
Message-Id: <1497624881-2315-17-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170616_165828_737202_49432884)
In-Reply-To: <1497624881-2315-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1497624881-2315-1-git-send-email-amit.karwar@redpinesignals.com>
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
