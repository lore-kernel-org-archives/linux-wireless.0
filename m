Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9585C433EF
	for <linux-wireless@archiver.kernel.org>; Tue, 21 Jun 2022 08:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347945AbiFUIEQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 21 Jun 2022 04:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345745AbiFUIEP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Jun 2022 04:04:15 -0400
Received: from smtpbg.qq.com (smtpbg123.qq.com [175.27.65.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD209598;
        Tue, 21 Jun 2022 01:04:10 -0700 (PDT)
X-QQ-mid: bizesmtp64t1655798569to3diblp
Received: from ubuntu.localdomain ( [106.117.99.68])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 21 Jun 2022 16:02:43 +0800 (CST)
X-QQ-SSF: 01000000007000109000B00A0000000
X-QQ-FEAT: 3uawQE1sH+15ESVN/mUMqlBrQavCfrbESV20r2NWb9hARlguSCCVrkgB1uAod
        FH4ylw1I6Jet/7iH/95HSbsQi8uTLUjkpqVc5w0G7zPDo1LgEtE2SL1X7MS70toRyuywasR
        p4K2ZE28XHifBlLdLcSocF2UILhEys3t3Fu06JGrcYPuPiH3nThknLppkdmPpu4HJCeMFhe
        OjpF1PZ1dcidWpmEK8qb9X+zmbKrX3j9eNatIHatmsUHrN66RAX5G+NdEcPi6tdfFNFHzp9
        b4izwS61sGSOVMJkUj+MWwHdq1ru36HKtQQqA/0JYX0QNvI5fTWXiXGEBD7kR85QVocC5aR
        W72z5Og
X-QQ-GoodBg: 0
From:   Jiang Jian <jiangjian@cdjrlc.com>
To:     toke@toke.dk
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jiangjian@cdjrlc.com
Subject: [PATCH] ath9k: remove unexpected words "the" in comments
Date:   Tue, 21 Jun 2022 16:02:40 +0800
Message-Id: <20220621080240.42198-1-jiangjian@cdjrlc.com>
X-Mailer: git-send-email 2.17.1
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam8
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

there is unexpected word "the" in comments need to remove

Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index fcfed8e59d29..ebdb97999335 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -498,7 +498,7 @@ static void ar9002_hw_spectral_scan_config(struct ath_hw *ah,
 	else
 		REG_CLR_BIT(ah, AR_PHY_SPECTRAL_SCAN, repeat_bit);
 
-	/* on AR92xx, the highest bit of count will make the the chip send
+	/* on AR92xx, the highest bit of count will make the chip send
 	 * spectral samples endlessly. Check if this really was intended,
 	 * and fix otherwise.
 	 */
-- 
2.17.1

