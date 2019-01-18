Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BC4DC5AE5E
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 23:12:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53E052054F
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 23:12:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730080AbfARXMg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 18:12:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45203 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729847AbfARXMg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 18:12:36 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1gkdJP-0006gf-PM; Fri, 18 Jan 2019 23:12:31 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Tony Lindgren <tony@atomide.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wlcore: clean up an indentation issue
Date:   Fri, 18 Jan 2019 23:12:31 +0000
Message-Id: <20190118231231.31577-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a goto statement that is missing a tab for indentation. Fix this.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 903968735a74..348be0aed97e 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -1427,7 +1427,7 @@ int wl1271_cmd_set_sta_key(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	ret = wl1271_cmd_send(wl, CMD_SET_KEYS, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
 		wl1271_warning("could not set keys");
-	goto out;
+		goto out;
 	}
 
 out:
-- 
2.19.1

