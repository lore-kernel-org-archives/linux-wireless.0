Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73FEEC282D8
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:55:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4635520855
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730720AbfA3Lzr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 06:55:47 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:52712 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728480AbfA3Lzq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 06:55:46 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gooT2-0003x8-Tf; Wed, 30 Jan 2019 13:55:45 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 30 Jan 2019 13:55:12 +0200
Message-Id: <20190130115528.19922-2-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190130115528.19922-1-luca@coelho.fi>
References: <20190130115528.19922-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 01/17] iwlwifi: bump FW API to 44 for 9000 and 22000 series
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Start supporting API version 44 where applicable.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index eb93711d474b..c547288d32aa 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -56,7 +56,7 @@
 #include "iwl-config.h"
 
 /* Highest firmware API version supported */
-#define IWL_22000_UCODE_API_MAX	43
+#define IWL_22000_UCODE_API_MAX	44
 
 /* Lowest firmware API version supported */
 #define IWL_22000_UCODE_API_MIN	39
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
index 113bcf7735a0..84adfd902002 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
@@ -57,7 +57,7 @@
 #include "fw/file.h"
 
 /* Highest firmware API version supported */
-#define IWL9000_UCODE_API_MAX	43
+#define IWL9000_UCODE_API_MAX	44
 
 /* Lowest firmware API version supported */
 #define IWL9000_UCODE_API_MIN	30
-- 
2.20.1

