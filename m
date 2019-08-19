Return-Path: <SRS0=IsUp=WP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 061C0C3A5A0
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Aug 2019 16:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D54F62070B
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Aug 2019 16:50:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbfHSQuX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Aug 2019 12:50:23 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:37032 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727873AbfHSQuV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Aug 2019 12:50:21 -0400
Received: from [91.156.6.193] (helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hzkrL-0007zi-GP; Mon, 19 Aug 2019 19:50:19 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 19 Aug 2019 19:49:54 +0300
Message-Id: <20190819165007.10181-10-luca@coelho.fi>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190819165007.10181-1-luca@coelho.fi>
References: <20190819165007.10181-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH v3 09/22] iwlwifi: add ldbg config cmd debug print
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

add support to print ldbg command in mvm and xvt mode

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index bf0b9ee05c44..2aa5320e9d1a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -414,6 +414,7 @@ static const struct iwl_hcmd_names iwl_mvm_legacy_names[] = {
 	HCMD_NAME(SCAN_ITERATION_COMPLETE),
 	HCMD_NAME(D0I3_END_CMD),
 	HCMD_NAME(LTR_CONFIG),
+	HCMD_NAME(LDBG_CONFIG_CMD),
 };
 
 /* Please keep this array *SORTED* by hex value.
-- 
2.23.0.rc1

