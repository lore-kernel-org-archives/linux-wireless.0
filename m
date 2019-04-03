Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D415C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 09:22:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E293120830
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 09:22:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfDCJWm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 05:22:42 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:49758 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726427AbfDCJWk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 05:22:40 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1hBc6Q-0007aR-Ho; Wed, 03 Apr 2019 12:22:38 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed,  3 Apr 2019 12:22:20 +0300
Message-Id: <20190403092224.815-10-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190403092224.815-1-luca@coelho.fi>
References: <20190403092224.815-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 09/13] iwlwifi: dbg: add lmac and umac PC registers to periphery dump
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 18e8ace5f72d..57e3f74c893c 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -545,6 +545,7 @@ static const struct iwl_prph_range iwl_prph_dump_addr_22000[] = {
 	{ .start = 0x00a04590, .end = 0x00a04590 },
 	{ .start = 0x00a04598, .end = 0x00a04598 },
 	{ .start = 0x00a045c0, .end = 0x00a045f4 },
+	{ .start = 0x00a05c18, .end = 0x00a05c1c },
 	{ .start = 0x00a0c000, .end = 0x00a0c018 },
 	{ .start = 0x00a0c020, .end = 0x00a0c028 },
 	{ .start = 0x00a0c038, .end = 0x00a0c094 },
@@ -559,6 +560,7 @@ static const struct iwl_prph_range iwl_prph_dump_addr_22000[] = {
 
 static const struct iwl_prph_range iwl_prph_dump_addr_ax210[] = {
 	{ .start = 0x00d03c00, .end = 0x00d03c64 },
+	{ .start = 0x00d05c18, .end = 0x00d05c1c },
 	{ .start = 0x00d0c000, .end = 0x00d0c174 },
 };
 
-- 
2.20.1

