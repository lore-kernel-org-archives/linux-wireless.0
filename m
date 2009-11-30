Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:45414 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbZK3RcO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:32:14 -0500
Date: Mon, 30 Nov 2009 18:32:20 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 06/11] mwl8k: add 2.4GHz channels 12, 13 and 14
Message-ID: <20091130173220.GV20214@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index c1ce985..cecabd6 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -243,6 +243,9 @@ static const struct ieee80211_channel mwl8k_channels[] = {
 	{ .center_freq = 2452, .hw_value = 9, },
 	{ .center_freq = 2457, .hw_value = 10, },
 	{ .center_freq = 2462, .hw_value = 11, },
+	{ .center_freq = 2467, .hw_value = 12, },
+	{ .center_freq = 2472, .hw_value = 13, },
+	{ .center_freq = 2484, .hw_value = 14, },
 };
 
 static const struct ieee80211_rate mwl8k_rates[] = {
-- 
1.5.6.4
