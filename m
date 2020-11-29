Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1A62C5519F
	for <linux-wireless@archiver.kernel.org>; Sun, 29 Nov 2020 13:15:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A786920705
	for <linux-wireless@archiver.kernel.org>; Sun, 29 Nov 2020 13:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgK2NPn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 29 Nov 2020 08:15:43 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:33440 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727902AbgK2NPh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Nov 2020 08:15:37 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1kjMXS-0035gF-Ff; Sun, 29 Nov 2020 15:14:50 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Sun, 29 Nov 2020 15:14:38 +0200
Message-Id: <iwlwifi.20201129151117.a25afe6d2c7f.I8f13a5689dd353825fb2b9bd5b6f0fbce92cb12b@changeid>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201129131442.1857561-1-luca@coelho.fi>
References: <20201129131442.1857561-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/12] iwlwifi: update MAINTAINERS entry
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Reflect the fact that the linuxwifi@intel.com address will disappear,
and that neither Emmanuel nor myself are really much involved with
the maintenance these days.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 MAINTAINERS | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e73636b75f29..cef21e97060d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9096,10 +9096,7 @@ S:	Supported
 F:	drivers/net/wireless/intel/iwlegacy/
 
 INTEL WIRELESS WIFI LINK (iwlwifi)
-M:	Johannes Berg <johannes.berg@intel.com>
-M:	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
 M:	Luca Coelho <luciano.coelho@intel.com>
-M:	Intel Linux Wireless <linuxwifi@intel.com>
 L:	linux-wireless@vger.kernel.org
 S:	Supported
 W:	https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi
-- 
2.29.2

