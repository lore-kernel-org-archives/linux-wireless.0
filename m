Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171Ab1HYPJB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:01 -0400
Date: Thu, 25 Aug 2011 17:07:24 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] cfg80211: document wiphy->registered
Message-ID: <20110825150723.GA32259@redhat.com> (sfid-20110825_173712_245474_EAEB9290)
References: <1313150459-13234-1-git-send-email-sgruszka@redhat.com>
 <1314248784.5054.44.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1314248784.5054.44.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 include/net/cfg80211.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 791dd10..f226552 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1784,6 +1784,7 @@ struct wiphy_wowlan_support {
  * @debugfsdir: debugfs directory used for this wiphy, will be renamed
  *	automatically on wiphy renames
  * @dev: (virtual) struct device for this wiphy
+ * @registered: helps synchronize suspend/resume with wiphy unregister
  * @wext: wireless extension handlers
  * @priv: driver private data (sized according to wiphy_new() parameter)
  * @interface_modes: bitmask of interfaces types valid for this wiphy,
-- 
1.7.1

