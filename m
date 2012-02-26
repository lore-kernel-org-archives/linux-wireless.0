Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:49460 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab2BZRlV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Feb 2012 12:41:21 -0500
From: Antonio Quartulli <ordex@autistici.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCH] mac80211_hwsim: correctly line up a multiline printk
Date: Sun, 26 Feb 2012 18:40:04 +0100
Message-Id: <1330278004-30691-1-git-send-email-ordex@autistici.org> (sfid-20120226_184124_651456_B8E3975D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The second line of a printk statement must line up to the opening bracket.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---
 drivers/net/wireless/mac80211_hwsim.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 4b9e730..0a7c1e5 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1580,7 +1580,7 @@ static int hwsim_register_received_nl(struct sk_buff *skb_2,
 	wmediumd_pid = info->snd_pid;
 
 	printk(KERN_DEBUG "mac80211_hwsim: received a REGISTER, "
-	"switching to wmediumd mode with pid %d\n", info->snd_pid);
+	       "switching to wmediumd mode with pid %d\n", info->snd_pid);
 
 	return 0;
 out:
-- 
1.7.3.4

