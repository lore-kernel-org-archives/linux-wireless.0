Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:5775 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755244AbYBMS6m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 13:58:42 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] wireless: update US regulatory domain
Date: Wed, 13 Feb 2008 20:58:34 +0200
Message-Id: <12029291143993-git-send-email-tomas.winkler@intel.com> (sfid-20080213_185857_772034_0F44D30E)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds channels to US regulatory domain

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/wireless/reg.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2b63c96..8cc6037 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -58,8 +58,14 @@ struct ieee80211_regdomain {
 static const struct ieee80211_channel_range ieee80211_US_channels[] = {
 	/* IEEE 802.11b/g, channels 1..11 */
 	RANGE_PWR(2412, 2462, 27, 6, 0),
-	/* IEEE 802.11a, channels 52..64 */
-	RANGE_PWR(5260, 5320, 23, 6, 0),
+	/* IEEE 802.11a, channel 36*/
+	RANGE_PWR(5180, 5180, 23, 6, 0),
+	/* IEEE 802.11a, channel 40*/
+	RANGE_PWR(5200, 5200, 23, 6, 0),
+	/* IEEE 802.11a, channel 44*/
+	RANGE_PWR(5220, 5220, 23, 6, 0),
+	/* IEEE 802.11a, channels 48..64 */
+	RANGE_PWR(5240, 5320, 23, 6, 0),
 	/* IEEE 802.11a, channels 149..165, outdoor */
 	RANGE_PWR(5745, 5825, 30, 6, 0),
 };
-- 
1.5.2.2

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

