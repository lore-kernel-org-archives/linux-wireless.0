Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:51486 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab1F3T0g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 15:26:36 -0400
Received: by fxd18 with SMTP id 18so2559967fxd.11
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2011 12:26:34 -0700 (PDT)
Message-Id: <0d4976ade6aa9b6b84f68f27c55ec75ec2e8f4d7.1309459253.git.chunkeey@googlemail.com> (sfid-20110630_212640_071561_8EF9744C)
In-Reply-To: <48506f4c6ef4578f748a77e2c7bca7374cf1a187.1309459253.git.chunkeey@googlemail.com>
References: <48506f4c6ef4578f748a77e2c7bca7374cf1a187.1309459253.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Thu, 30 Jun 2011 20:31:34 +0200
Subject: [PATCH 2/3] carl9170: enable IEEE80211_HW_NEED_DTIM_PERIOD
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 54d093c..06b9d49 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1577,6 +1577,7 @@ void *carl9170_alloc(size_t priv_size)
 		     IEEE80211_HW_REPORTS_TX_ACK_STATUS |
 		     IEEE80211_HW_SUPPORTS_PS |
 		     IEEE80211_HW_PS_NULLFUNC_STACK |
+		     IEEE80211_HW_NEED_DTIM_PERIOD |
 		     IEEE80211_HW_SIGNAL_DBM;
 
 	if (!modparam_noht) {
-- 
1.7.5.4

