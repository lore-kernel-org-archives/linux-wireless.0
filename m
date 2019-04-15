Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 482D3C10F0E
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 10:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17CCB2064A
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 10:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfDOKhJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 06:37:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51158 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfDOKhJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 06:37:09 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hFyz1-00068r-Uq; Mon, 15 Apr 2019 10:37:04 +0000
From:   Colin King <colin.king@canonical.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iwlegacy: fix spelling mistake "acumulative" -> "accumulative"
Date:   Mon, 15 Apr 2019 11:37:03 +0100
Message-Id: <20190415103703.11254-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Fix spelling mistakes in rx stats text. I missed these from an earlier
round of fixing the same spelling mistake.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/intel/iwlegacy/3945-debug.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/3945-debug.c b/drivers/net/wireless/intel/iwlegacy/3945-debug.c
index a2960032be81..4b912e707f38 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-debug.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-debug.c
@@ -185,7 +185,7 @@ il3945_ucode_rx_stats_read(struct file *file, char __user *user_buf,
 	pos +=
 	    scnprintf(buf + pos, bufsz - pos,
 		      "%-32s     current"
-		      "acumulative       delta         max\n",
+		      "accumulative      delta         max\n",
 		      "Statistics_Rx - CCK:");
 	pos +=
 	    scnprintf(buf + pos, bufsz - pos,
@@ -273,7 +273,7 @@ il3945_ucode_rx_stats_read(struct file *file, char __user *user_buf,
 	pos +=
 	    scnprintf(buf + pos, bufsz - pos,
 		      "%-32s     current"
-		      "acumulative       delta         max\n",
+		      "accumulative      delta         max\n",
 		      "Statistics_Rx - GENERAL:");
 	pos +=
 	    scnprintf(buf + pos, bufsz - pos,
@@ -346,7 +346,7 @@ il3945_ucode_tx_stats_read(struct file *file, char __user *user_buf,
 	pos +=
 	    scnprintf(buf + pos, bufsz - pos,
 		      "%-32s     current"
-		      "acumulative       delta         max\n",
+		      "accumulative      delta         max\n",
 		      "Statistics_Tx:");
 	pos +=
 	    scnprintf(buf + pos, bufsz - pos,
@@ -447,7 +447,7 @@ il3945_ucode_general_stats_read(struct file *file, char __user *user_buf,
 	pos +=
 	    scnprintf(buf + pos, bufsz - pos,
 		      "%-32s     current"
-		      "acumulative       delta         max\n",
+		      "accumulative      delta         max\n",
 		      "Statistics_General:");
 	pos +=
 	    scnprintf(buf + pos, bufsz - pos,
-- 
2.20.1

