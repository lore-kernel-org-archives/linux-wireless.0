Return-Path: <SRS0=Zq5x=5F=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F6A9C4332D
	for <linux-wireless@archiver.kernel.org>; Fri, 20 Mar 2020 13:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1C2B20754
	for <linux-wireless@archiver.kernel.org>; Fri, 20 Mar 2020 13:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbgCTNly (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 20 Mar 2020 09:41:54 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:46324 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbgCTNly (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Mar 2020 09:41:54 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jFHuJ-00AxSp-67; Fri, 20 Mar 2020 14:41:51 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] cfg80211: fix documentation format
Date:   Fri, 20 Mar 2020 14:41:11 +0100
Message-Id: <20200320144110.2786ad5fb234.I369d103d11c71e39e3a3f97ed68a528c5b875f1e@changeid>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Kernel-doc complains if the line isn't prefixed with an
asterisk, fix that.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f7c84c32ba39..e511b225be29 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3404,7 +3404,7 @@ struct cfg80211_update_owe_info {
  * @set_default_key: set the default key on an interface
  *
  * @set_default_mgmt_key: set the default management frame key on an interface
-
+ *
  * @set_default_beacon_key: set the default Beacon frame key on an interface
  *
  * @set_rekey_data: give the data necessary for GTK rekeying to the driver
-- 
2.25.1

