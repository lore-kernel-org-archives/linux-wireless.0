Return-Path: <SRS0=C9SN=YM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68871CA9EAF
	for <linux-wireless@archiver.kernel.org>; Sat, 19 Oct 2019 09:39:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40AB7222C2
	for <linux-wireless@archiver.kernel.org>; Sat, 19 Oct 2019 09:39:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfJSJjN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 19 Oct 2019 05:39:13 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:50406 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725812AbfJSJjM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 Oct 2019 05:39:12 -0400
Received: from [91.156.6.193] (helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1iLlCY-0002fy-Hf; Sat, 19 Oct 2019 12:39:11 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Sat, 19 Oct 2019 12:38:53 +0300
Message-Id: <20191019093902.29823-2-luca@coelho.fi>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191019093902.29823-1-luca@coelho.fi>
References: <20191019093902.29823-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 03/12] iwlwifi: nvm: update iwl_uhb_nvm_channels
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Tova Mussai <tova.mussai@intel.com>

Update uhb channels numbers to start from 1

Signed-off-by: Tova Mussai <tova.mussai@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index b0a0901ce0f3..1e240a2a8329 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -156,11 +156,10 @@ static const u16 iwl_uhb_nvm_channels[] = {
 	96, 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140, 144,
 	149, 153, 157, 161, 165, 169, 173, 177, 181,
 	/* 6-7 GHz */
-	189, 193, 197, 201, 205, 209, 213, 217, 221, 225, 229, 233, 237, 241,
-	245, 249, 253, 257, 261, 265, 269, 273, 277, 281, 285, 289, 293, 297,
-	301, 305, 309, 313, 317, 321, 325, 329, 333, 337, 341, 345, 349, 353,
-	357, 361, 365, 369, 373, 377, 381, 385, 389, 393, 397, 401, 405, 409,
-	413, 417, 421
+	1, 5, 9, 13, 17, 21, 25, 29, 33, 37, 41, 45, 49, 53, 57, 61, 65, 69,
+	73, 77, 81, 85, 89, 93, 97, 101, 105, 109, 113, 117, 121, 125, 129,
+	133, 137, 141, 145, 149, 153, 157, 161, 165, 169, 173, 177, 181, 185,
+	189, 193, 197, 201, 205, 209, 213, 217, 221, 225, 229, 233
 };
 
 #define IWL_NVM_NUM_CHANNELS		ARRAY_SIZE(iwl_nvm_channels)
-- 
2.23.0

