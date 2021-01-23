Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D76C433E0
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Jan 2021 06:16:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AB2523B08
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Jan 2021 06:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbhAWGQe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 23 Jan 2021 01:16:34 -0500
Received: from m12-11.163.com ([220.181.12.11]:56488 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726063AbhAWGQc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Jan 2021 01:16:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=xCn6p9NJsojGDEOK0g
        fOq+HkZhp0fhqQy2JmR2QKavs=; b=hC0JhGapZYlivTTwT9L3oo9htgWFEXjK5F
        NZiUxfwRgN2yt+msQZEnRmcTCRm30TyIh3ftsVPh35Haq7EB9M2ol7gexRCAkm8E
        WSkHilQFfO+Xuukh7F3VhIqkFXG58ImXSWUNYmiDpZTNQeyA5vnbpbR9RVLRam0g
        hAGTl1560=
Received: from wengjianfeng.ccdomain.com (unknown [218.17.89.92])
        by smtp7 (Coremail) with SMTP id C8CowACHLp5yswtgvh2zKA--.10027S2;
        Sat, 23 Jan 2021 13:26:11 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     mgreer@animalcreek.com
Cc:     linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] nfc: fix typo
Date:   Sat, 23 Jan 2021 13:26:18 +0800
Message-Id: <20210123052618.2448-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: C8CowACHLp5yswtgvh2zKA--.10027S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtrW7Cw4DArW7tr1UXrWxCrg_yoWxKwbE9r
        1kXrW7Xr97ur1jkr1UC3Z0vFyFy3W5WF9a9Fsa9FWSkryFyF47uw18uF1fXw15JrW5JFnr
        uwnFg34Syw13WjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUYqJmUUUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/xtbBHBMjsV3l+aXMggAAs3
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

change 'regster' to 'register'

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/nfc/trf7970a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index c70f62fe..3397802 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -169,7 +169,7 @@
 
 /* Bits determining whether its a direct command or register R/W,
  * whether to use a continuous SPI transaction or not, and the actual
- * direct cmd opcode or regster address.
+ * direct cmd opcode or register address.
  */
 #define TRF7970A_CMD_BIT_CTRL			BIT(7)
 #define TRF7970A_CMD_BIT_RW			BIT(6)
-- 
1.9.1

