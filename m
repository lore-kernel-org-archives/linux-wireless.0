Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34178 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753612AbdFMOwi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 10:52:38 -0400
Received: by mail-pg0-f67.google.com with SMTP id v14so19234388pgn.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jun 2017 07:52:38 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Alexey.Brodkin@synopsys.com,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 16/20] rsi: rename variable in_sdio_litefi_irq
Date: Tue, 13 Jun 2017 20:19:04 +0530
Message-Id: <1497365348-2305-17-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170613_170119_809317_EE6DC92F)
In-Reply-To: <1497365348-2305-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1497365348-2305-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karun Eagalapati <karun256@gmail.com>

The variable in_sdio_litefi_irq is renamed to sdio_irq_task,
as it is more relevant here.

Signed-off-by: Karun Eagalapati <karun256@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
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
