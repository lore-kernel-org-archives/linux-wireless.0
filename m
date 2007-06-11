Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18445 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755578AbXFKJAt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 05:00:49 -0400
Date: Mon, 11 Jun 2007 16:59:50 +0800
From: Zhu Yi <yi.zhu@intel.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [Take 2] mac80211 IEEE802.11e/WMM code cleanup
Message-ID: <20070611085950.GA5540@mail.intel.com>
Reply-To: yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Linville,

Here is a V2 patch series to cleanup the 11e/WMM code in wireless-dev
GIT head 3480b61c08559777c57b95e346507b26253ca8bb after reviewed by
Johannes Berg. Please apply.

[PATCH 1/6] mac80211: Add IEEE80211_ prefix to SET_TSINFO_{} macros
[PATCH 2/6] mac80211: Fix TSINFO macros endian issue
[PATCH 3/6] mac80211: fix typo in net/mac80211/ieee80211_sta.c
[PATCH 4/6] mac80211: remove global tsinfo debugfs variables
[PATCH 5/6] mac80211: Fix sparse error for the IEEE802.11e/WMM code
[PATCH 6/6] mac80211: Fix sparse error for sta_last_seq_ctrl_read

Thanks,
-yi
