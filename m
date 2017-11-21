Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:33284 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751145AbdKUVNj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 16:13:39 -0500
From: Guilherme Tadashi Maeoka <gui.maeoka@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Guilherme Tadashi Maeoka <gui.maeoka@gmail.com>
Subject: [PATCH 2/2] Net: wireless: nl80211: fix coding style
Date: Tue, 21 Nov 2017 19:13:32 -0200
Message-Id: <20171121211332.3066-1-gui.maeoka@gmail.com> (sfid-20171121_221608_248155_D9AE3175)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix some coding styles.

Signed-off-by: Guilherme Tadashi Maeoka <gui.maeoka@gmail.com>
---
 net/wireless/nl80211.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b1ac23ca20c8..0d7e77e03db5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13994,7 +13994,7 @@ void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
 }
 
 void cfg80211_notify_new_peer_candidate(struct net_device *dev, const u8 *addr,
-					const u8* ie, u8 ie_len, gfp_t gfp)
+					const u8 *ie, u8 ie_len, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
@@ -14020,7 +14020,7 @@ void cfg80211_notify_new_peer_candidate(struct net_device *dev, const u8 *addr,
 	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
 	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, addr) ||
 	    (ie_len && ie &&
-	     nla_put(msg, NL80211_ATTR_IE, ie_len , ie)))
+	     nla_put(msg, NL80211_ATTR_IE, ie_len, ie)))
 		goto nla_put_failure;
 
 	genlmsg_end(msg, hdr);
@@ -15158,7 +15158,7 @@ void cfg80211_tdls_oper_request(struct net_device *dev, const u8 *peer,
 }
 EXPORT_SYMBOL(cfg80211_tdls_oper_request);
 
-static int nl80211_netlink_notify(struct notifier_block * nb,
+static int nl80211_netlink_notify(struct notifier_block *nb,
 				  unsigned long state,
 				  void *_notify)
 {
-- 
2.15.0
