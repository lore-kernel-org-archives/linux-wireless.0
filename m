Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3768DC10F01
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 09:27:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FB5E2147A
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 09:27:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfBTJ1i (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 04:27:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48942 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfBTJ1h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 04:27:37 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1gwOA3-0000RL-U9; Wed, 20 Feb 2019 09:27:28 +0000
From:   Colin King <colin.king@canonical.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] rtlwifi: rtl8192ce: fix typo, "PairwiseENcAlgorithm" -> "PairwiseEncAlgorithm"
Date:   Wed, 20 Feb 2019 09:27:27 +0000
Message-Id: <20190220092727.17119-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is an uppercase 'N' that should be a lowercase 'n', fix this.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
index 5cf5a85d1376..d8f496e2d68b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
@@ -876,7 +876,7 @@ void rtl92ce_enable_hw_security_config(struct ieee80211_hw *hw)
 	u8 sec_reg_value;
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
-		 "PairwiseENcAlgorithm = %d GroupEncAlgorithm = %d\n",
+		 "PairwiseEncAlgorithm = %d GroupEncAlgorithm = %d\n",
 		 rtlpriv->sec.pairwise_enc_algorithm,
 		 rtlpriv->sec.group_enc_algorithm);
 
-- 
2.20.1

