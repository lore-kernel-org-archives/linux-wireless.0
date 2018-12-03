Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B3D6C04EBF
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 11:48:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 197CE20851
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 11:48:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 197CE20851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=v3.sk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbeLCLsn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 06:48:43 -0500
Received: from shell.v3.sk ([90.176.6.54]:37935 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbeLCLsm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 06:48:42 -0500
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 7D2E3C8137;
        Mon,  3 Dec 2018 12:47:57 +0100 (CET)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id wizFHgYfgQl9; Mon,  3 Dec 2018 12:47:49 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 7B24BC8130;
        Mon,  3 Dec 2018 12:47:49 +0100 (CET)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id tUBNTCqnCbVD; Mon,  3 Dec 2018 12:47:48 +0100 (CET)
Received: from belphegor.brq.redhat.com (nat-pool-brq-t.redhat.com [213.175.37.10])
        by zimbra.v3.sk (Postfix) with ESMTPSA id 18A46C805D;
        Mon,  3 Dec 2018 12:47:48 +0100 (CET)
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Jiri Kosina <trivial@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] mac80211: a trivial open80211s web site URL fix
Date:   Mon,  3 Dec 2018 12:47:45 +0100
Message-Id: <20181203114745.637240-1-lkundrak@v3.sk>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 net/mac80211/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index f869e35d0974..bbd3d30625d8 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -64,7 +64,7 @@ config MAC80211_MESH
 	 The implementation is based on Draft 2.08 of the Mesh Networking
 	 amendment.  However, no compliance with that draft is claimed or even
 	 possible, as drafts leave a number of identifiers to be defined after
-	 ratification.  For more information visit http://o11s.org/.
+	 ratification.  For more information visit http://open80211s.org/.
=20
 config MAC80211_LEDS
 	bool "Enable LED triggers"
--=20
2.19.1

