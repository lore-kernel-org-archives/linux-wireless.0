Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0914C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 14:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 808DE205C9
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 14:36:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbfAQOga (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 09:36:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41553 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbfAQOga (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 09:36:30 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1gk8mN-00071h-LD; Thu, 17 Jan 2019 14:36:23 +0000
From:   Colin King <colin.king@canonical.com>
To:     Solomon Peachy <pizza@shaftnet.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cw1200: fix indentation issues
Date:   Thu, 17 Jan 2019 14:36:23 +0000
Message-Id: <20190117143623.29363-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are two lines that have indentation issues, fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/st/cw1200/fwio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/fwio.c b/drivers/net/wireless/st/cw1200/fwio.c
index 30e7646d04af..b7881232499c 100644
--- a/drivers/net/wireless/st/cw1200/fwio.c
+++ b/drivers/net/wireless/st/cw1200/fwio.c
@@ -465,8 +465,8 @@ int cw1200_load_firmware(struct cw1200_common *priv)
 
 	if (!(val32 & ST90TDS_CONFIG_ACCESS_MODE_BIT)) {
 		pr_err("Device is already in QUEUE mode!\n");
-			ret = -EINVAL;
-			goto out;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	switch (priv->hw_type)  {
-- 
2.19.1

