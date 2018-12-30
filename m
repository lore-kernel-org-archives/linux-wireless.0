Return-Path: <SRS0=Iw3I=PH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D466C43387
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Dec 2018 13:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7566C20828
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Dec 2018 13:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbeL3NiF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 30 Dec 2018 08:38:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51113 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbeL3NiF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Dec 2018 08:38:05 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1gdbI2-0003Qu-AX; Sun, 30 Dec 2018 13:38:02 +0000
From:   Colin King <colin.king@canonical.com>
To:     Samuel Ortiz <sameo@linux.intel.com>,
        Daniel Mack <daniel@zonque.org>, linux-wireless@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] NFC: st95hf: clean up indentation, add in missing tab on return statement
Date:   Sun, 30 Dec 2018 13:38:01 +0000
Message-Id: <20181230133801.7237-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

A return statement is not indented enough, fix this by adding the
missing tab.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/nfc/st95hf/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index a50a95cfcfd8..76d0ed14d6af 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -672,7 +672,7 @@ static int st95hf_error_handling(struct st95hf_context *stcontext,
 			result = -ETIMEDOUT;
 		else
 			result = -EIO;
-	return  result;
+		return  result;
 	}
 
 	/* Check for CRC err only if CRC is present in the tag response */
-- 
2.19.1

