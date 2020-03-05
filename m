Return-Path: <SRS0=q56x=4W=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53DA0C3F2CD
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Mar 2020 12:26:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3049E2072A
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Mar 2020 12:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgCEM0h (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 5 Mar 2020 07:26:37 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:60694 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725880AbgCEM0h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Mar 2020 07:26:37 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <luca@coelho.fi>)
        id 1j9paF-0005Nb-J7; Thu, 05 Mar 2020 14:26:36 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Thu,  5 Mar 2020 14:26:22 +0200
Message-Id: <iwlwifi.20200305142622.3b1f9018cd2e.Iccbce3e78befd4ac39735b26617cfb6a12a2ae5a@changeid>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH] MAINTAINERS: update web URL for iwlwifi
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

The current URL mentioned in iwlwifi's W entry is outdated and
currently pointing to a dead link.  Change it so that it points to the
correct Wiki page directly.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 38fe2f3f7b6f..95089499876f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8684,7 +8684,7 @@ M:	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
 M:	Luca Coelho <luciano.coelho@intel.com>
 M:	Intel Linux Wireless <linuxwifi@intel.com>
 L:	linux-wireless@vger.kernel.org
-W:	http://intellinuxwireless.org
+W:	https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git
 S:	Supported
 F:	drivers/net/wireless/intel/iwlwifi/
-- 
2.25.1

