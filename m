Return-Path: <SRS0=xI28=P5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5FA5C282DB
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:50:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DE592084A
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 07:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbfAUHui (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jan 2019 02:50:38 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:49052 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728753AbfAUHuh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jan 2019 02:50:37 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1glULr-0006cr-Du; Mon, 21 Jan 2019 09:50:35 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Mon, 21 Jan 2019 09:50:14 +0200
Message-Id: <20190121075026.25059-5-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190121075026.25059-1-luca@coelho.fi>
References: <20190121075026.25059-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 04/16] iwlwifi: fix spelling mistake "registrating" -> "registering"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in IWL_ERR error message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index c219bca5cff4..bd3c3b921d4c 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -1054,7 +1054,7 @@ static void iwl_bg_restart(struct work_struct *data)
 			ieee80211_restart_hw(priv->hw);
 		else
 			IWL_ERR(priv,
-				"Cannot request restart before registrating with mac80211\n");
+				"Cannot request restart before registering with mac80211\n");
 	} else {
 		WARN_ON(1);
 	}
-- 
2.20.1

