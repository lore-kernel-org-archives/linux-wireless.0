Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51969 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518Ab3GKMUo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 08:20:44 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 3/3] iw: add the active monitor flag
Date: Thu, 11 Jul 2013 14:20:39 +0200
Message-Id: <1373545239-78697-3-git-send-email-nbd@openwrt.org> (sfid-20130711_142047_935765_2A431187)
In-Reply-To: <1373545239-78697-1-git-send-email-nbd@openwrt.org>
References: <1373545239-78697-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 interface.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/interface.c b/interface.c
index b52c8dd..f769752 100644
--- a/interface.c
+++ b/interface.c
@@ -16,7 +16,8 @@
 			"fcsfail:  show frames with FCS errors\n"\
 			"control:  show control frames\n"\
 			"otherbss: show frames from other BSSes\n"\
-			"cook:     use cooked mode"
+			"cook:     use cooked mode\n"\
+			"active:   use active mode (ACK incoming unicast packets)"
 
 SECTION(interface);
 
@@ -27,6 +28,7 @@ static char *mntr_flags[NL80211_MNTR_FLAG_MAX + 1] = {
 	"control",
 	"otherbss",
 	"cook",
+	"active",
 };
 
 static int parse_mntr_flags(int *_argc, char ***_argv,
-- 
1.8.0.2

