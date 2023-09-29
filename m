Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FAF1E71D3A
	for <linux-wireless@archiver.kernel.org>; Fri, 29 Sep 2023 13:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbjI2N6W (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 29 Sep 2023 09:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbjI2N6W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2023 09:58:22 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:242:246e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73745DB
        for <linux-wireless@vger.kernel.org>; Fri, 29 Sep 2023 06:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=bKzQ8rWP/FfrgiPOGp7mbA0NlcIqwZuF6xHrG2k7GGQ=; t=1695995900; x=1697205500; 
        b=moQBuMgF5AoFQLVVvo+e8WelfmKrpSxe8cJuMDyjSaGYotZH4ux6uuH16mFcd+H4GsHOPkPTRu8
        2qesH0NWvHaL9IEYycPb9hMMW4mTFstL9VRQ5F9cb9gkioxcsicHgsop2l8DfHyIP9fc+kj15XMTh
        e/6kGmZ4OSnHJnGRJup4HQvQMpdj4cfZ1Bl6hgD37uvKyg+CahjK4tcOMNxuI0fG9JX0nZYK91DA6
        YhIm6G4pIS/ENls6wMVL1wR2ELUwtAOjOvUFOA+aoSeK/gpMAlJjMZNl/IszWIcOHdqTDzswXuujS
        W/BncDDcMIXh6cdTEOCz2ELzcJCKydf4BnoA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1qmE0X-00BkTa-0f;
        Fri, 29 Sep 2023 15:58:17 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wifi: mac80211: add back SPDX identifier
Date:   Fri, 29 Sep 2023 15:58:14 +0200
Message-ID: <20230929155813.9ec1cc7b8f7e.Ia8ee49c10d265963412c9129a64d4a1dbcb10e78@changeid>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Looks like I lost that by accident, add it back.

Fixes: 076fc8775daf ("wifi: cfg80211: remove wdev mutex")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6a078eb23a5d..2ac36ad9fa91 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * BSS client mode implementation
  * Copyright 2003-2008, Jouni Malinen <j@w1.fi>
-- 
2.41.0

