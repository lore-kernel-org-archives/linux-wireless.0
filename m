Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:51409 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586AbbJVBDl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 21:03:41 -0400
Date: Thu, 22 Oct 2015 08:58:59 +0800
From: kbuild test robot <lkp@intel.com>
To: greearb@candelatech.com
Cc: kbuild-all@01.org, linux-wireless@vger.kernel.org,
	ath6kl@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [RFC PATCH] ath6k: ath6k_ethtool_ops can be static
Message-ID: <20151022005858.GA48311@xian> (sfid-20151022_030343_631140_19A5A224)
References: <201510220815.XZd9VwIK%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445471597-26091-2-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 cfg80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index c6eb2fd..e8dbe9b 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3747,7 +3747,7 @@ static void ath6k_get_strings(struct net_device *dev, u32 sset, u8 *data)
 	}
 }
 
-const struct ethtool_ops ath6k_ethtool_ops = {
+static const struct ethtool_ops ath6k_ethtool_ops = {
 	.get_drvinfo = cfg80211_get_drvinfo,
 	.get_link = ethtool_op_get_link,
 	.get_strings = ath6k_get_strings,
