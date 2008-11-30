Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:54668 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbYK3S4e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Nov 2008 13:56:34 -0500
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx09.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id mAUIuVBx015353
	for <linux-wireless@vger.kernel.org>; Sun, 30 Nov 2008 12:56:32 -0600
Received: from localhost.localdomain (essapo-nirac253237.europe.nokia.com [10.162.253.237])
	by mgw-int01.ntc.nokia.com (Switch-3.2.5/Switch-3.2.5) with ESMTP id mAUIuSQr021554
	for <linux-wireless@vger.kernel.org>; Sun, 30 Nov 2008 20:56:29 +0200
From: Kalle Valo <kalle.valo@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: document ieee80211_tx_info.pad
Date: Sun, 30 Nov 2008 20:56:28 +0200
Message-Id: <1228071388-19303-1-git-send-email-kalle.valo@nokia.com> (sfid-20081130_195648_258951_400D8BCE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes htmldocs warning:

Warning(mac80211.h:379): No description found for parameter 'pad[2]'

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 include/net/mac80211.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6a1d4ea..287f7be 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -323,6 +323,7 @@ struct ieee80211_tx_rate {
  * @flags: transmit info flags, defined above
  * @band: the band to transmit on (use for checking for races)
  * @antenna_sel_tx: antenna to use, 0 for automatic diversity
+ * @pad: padding, ignore
  * @control: union for control data
  * @status: union for status data
  * @driver_data: array of driver_data pointers
-- 
1.5.6.5

