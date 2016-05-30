Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33801 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbcE3CyS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 May 2016 22:54:18 -0400
Date: Sun, 29 May 2016 19:54:10 -0700
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, ruchandani.tina@gmail.com,
	netdev@vger.kernel.org, Julian.Calaby@gmail.com
Subject: [PATCH v2 08/10] nl80211: Fix spelling
Message-ID: <44f8047ab65f9c6aa190eb870590102cd2297ab1.1464576022.git.kirtika.ruchandani@gmail.com> (sfid-20160530_045424_212760_611DE700)
References: <cover.1464576022.git.kirtika.ruchandani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1464576022.git.kirtika.ruchandani@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'implementation' spelling, reported by checkpatch.pl

Signed-off-by: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 6f8e2a7..c6d870e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6492,7 +6492,7 @@ nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 				       nla_data(ssid), nla_len(ssid));
 				request->match_sets[i].ssid.ssid_len =
 					nla_len(ssid);
-				/* special attribute - old implemenation w/a */
+				/* special attribute - old implementation w/a */
 				request->match_sets[i].rssi_thold =
 					default_match_rssi;
 				rssi = tb[NL80211_SCHED_SCAN_MATCH_ATTR_RSSI];
--
2.8.0.rc3.226.g39d4020

