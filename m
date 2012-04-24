Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18604 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300Ab2DXNQv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 09:16:51 -0400
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [RFCv2 3/6] hwsim: Adds support for BT SOFTAMP for testing
Date: Tue, 24 Apr 2012 16:17:37 +0300
Message-Id: <1335273460-12682-4-git-send-email-Andrei.Emeltchenko.news@gmail.com> (sfid-20120424_151702_337019_38B891BF)
In-Reply-To: <1335273460-12682-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
References: <1335273460-12682-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>


Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index b7ce6a6..bff3699 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1783,7 +1783,8 @@ static int __init init_mac80211_hwsim(void)
 			BIT(NL80211_IFTYPE_P2P_CLIENT) |
 			BIT(NL80211_IFTYPE_P2P_GO) |
 			BIT(NL80211_IFTYPE_ADHOC) |
-			BIT(NL80211_IFTYPE_MESH_POINT);
+			BIT(NL80211_IFTYPE_MESH_POINT) |
+			BIT(NL80211_IFTYPE_BLUETOOTH_SOFTAMP);
 
 		hw->flags = IEEE80211_HW_MFP_CAPABLE |
 			    IEEE80211_HW_SIGNAL_DBM |
-- 
1.7.9.5

