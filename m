Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38139 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbaLAQA1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 11:00:27 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so25056956wiv.11
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2014 08:00:26 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] iw: print phy TDLS ch-switch support
Date: Mon,  1 Dec 2014 18:00:22 +0200
Message-Id: <1417449622-10583-1-git-send-email-arik@wizery.com> (sfid-20141201_170030_273626_6C45BA02)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 info.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/info.c b/info.c
index 7499290..7f8c832 100644
--- a/info.c
+++ b/info.c
@@ -587,6 +587,8 @@ broken_combination:
 			printf("\tDevice supports WMM-AC admission (TSPECs)\n");
 		if (features & NL80211_FEATURE_MAC_ON_CREATE)
 			printf("\tDevice supports configuring vdev MAC-addr on create.\n");
+		if (features & NL80211_FEATURE_TDLS_CHANNEL_SWITCH)
+			printf("\tDevice supports TDLS channel switching\n");
 	}
 
 	if (tb_msg[NL80211_ATTR_TDLS_SUPPORT])
-- 
1.9.1

