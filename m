Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26D73C433E9
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Feb 2021 09:12:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC82564F87
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Feb 2021 09:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhBEJMH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Feb 2021 04:12:07 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:43740 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230110AbhBEJHf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Feb 2021 04:07:35 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1l7x4h-0044i1-BA; Fri, 05 Feb 2021 11:06:47 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri,  5 Feb 2021 11:06:32 +0200
Message-Id: <iwlwifi.20210205110447.7b908f5dd970.Id2aec0d7d33921aba77ba9853196f81d5950c31c@changeid>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205090642.1553849-1-luca@coelho.fi>
References: <20210205090642.1553849-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [RESEND PATCH 02/12] iwlwifi: bump FW API to 60 for AX devices
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Start supporting API version 60 for AX devices.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index 7220fc8fd9b0..d6c88c813880 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -9,7 +9,7 @@
 #include "iwl-prph.h"
 
 /* Highest firmware API version supported */
-#define IWL_22000_UCODE_API_MAX	59
+#define IWL_22000_UCODE_API_MAX	60
 
 /* Lowest firmware API version supported */
 #define IWL_22000_UCODE_API_MIN	39
-- 
2.30.0

