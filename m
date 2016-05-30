Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:34373 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbcE3Cyk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 May 2016 22:54:40 -0400
Date: Sun, 29 May 2016 19:54:28 -0700
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, ruchandani.tina@gmail.com,
	netdev@vger.kernel.org, Julian.Calaby@gmail.com
Subject: [PATCH v2 09/10] nl80211: Fix checkpatch.pl warning
Message-ID: <2b42b54b8128bb953569021ddadce77499859a79.1464576022.git.kirtika.ruchandani@gmail.com> (sfid-20160530_045451_322827_4DDB7B79)
References: <cover.1464576022.git.kirtika.ruchandani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1464576022.git.kirtika.ruchandani@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the checkpatch.pl warning "foo * bar should be
foo *bar"

Signed-off-by: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
---
 net/wireless/nl80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c6d870e..46757af 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -12214,7 +12214,7 @@ void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
 }

 void cfg80211_notify_new_peer_candidate(struct net_device *dev, const u8 *addr,
-					const u8* ie, u8 ie_len, gfp_t gfp)
+					const u8 *ie, u8 ie_len, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
@@ -13362,7 +13362,7 @@ void cfg80211_tdls_oper_request(struct net_device *dev, const u8 *peer,
 }
 EXPORT_SYMBOL(cfg80211_tdls_oper_request);

-static int nl80211_netlink_notify(struct notifier_block * nb,
+static int nl80211_netlink_notify(struct notifier_block *nb,
 				  unsigned long state,
 				  void *_notify)
 {
--
2.8.0.rc3.226.g39d4020

