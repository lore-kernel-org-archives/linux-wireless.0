Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:37136 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753411AbdHXWCg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 18:02:36 -0400
From: Himanshu Jha <himanshujha199640@gmail.com>
To: johannes@sipsolutions.net
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH] cfg80211: Use tabs for identation
Date: Fri, 25 Aug 2017 03:32:08 +0530
Message-Id: <1503612128-28782-1-git-send-email-himanshujha199640@gmail.com> (sfid-20170825_000252_147308_FF46F68A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removed whitespaces and added necessary tabs conforming to coding style.
Issue found using checkpatch.pl

Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
---
 net/wireless/chan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index b8aa5a7..13c95e5 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -984,9 +984,9 @@ int cfg80211_set_monitor_channel(struct cfg80211_registered_device *rdev,
 
 void
 cfg80211_get_chan_state(struct wireless_dev *wdev,
-		        struct ieee80211_channel **chan,
-		        enum cfg80211_chan_mode *chanmode,
-		        u8 *radar_detect)
+			struct ieee80211_channel **chan,
+			enum cfg80211_chan_mode *chanmode,
+			u8 *radar_detect)
 {
 	int ret;
 
-- 
2.7.4
