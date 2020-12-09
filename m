Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91814C4361B
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Dec 2020 21:19:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60E6622C7D
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Dec 2020 21:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387954AbgLIVTT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Dec 2020 16:19:19 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:35748 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728003AbgLIVTT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Dec 2020 16:19:19 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1kn6po-003Drx-Ip; Wed, 09 Dec 2020 23:17:16 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Wed,  9 Dec 2020 23:16:34 +0200
Message-Id: <iwlwifi.20201209231352.6a9203094c1e.I658e63066b05257e78fc20bfcbcf151ba8fd7754@changeid>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201209211651.968276-1-luca@coelho.fi>
References: <20201209211651.968276-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH v2 30/47] iwlwifi: fw: file: fix documentation for SAR flag
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

This was mistakenly tagged with CAPA instead of API, fix it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/file.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index e79c1faca95f..934f2f9bcc2c 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -288,7 +288,7 @@ typedef unsigned int __bitwise iwl_ucode_tlv_api_t;
  *	SCAN_OFFLOAD_PROFILES_QUERY_RSP_S.
  * @IWL_UCODE_TLV_API_MBSSID_HE: This ucode supports v2 of
  *	STA_CONTEXT_DOT11AX_API_S
- * @IWL_UCODE_TLV_CAPA_SAR_TABLE_VER: This ucode supports different sar
+ * @IWL_UCODE_TLV_API_SAR_TABLE_VER: This ucode supports different sar
  *	version tables.
  * @IWL_UCODE_TLV_API_REDUCED_SCAN_CONFIG: This ucode supports v3 of
  *  SCAN_CONFIG_DB_CMD_API_S.
-- 
2.29.2

