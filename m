Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:38582 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968826AbXFHRDZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 13:03:25 -0400
Date: Sat, 9 Jun 2007 01:02:42 +0800
From: Zhu Yi <yi.zhu@intel.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: mac80211 IEEE802.11e/WMM code cleanup
Message-ID: <20070608170242.GA17235@mail.intel.com>
Reply-To: yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

Here is a patch series to cleanup the 11e/WMM code in wireless-dev
GIT head. Please apply.

[PATCH 1/6] mac80211: Add IEEE80211_ prefix to SET_TSINFO_XXX macros
[PATCH 2/6] mac80211: remove global tsinfo debugfs variables
[PATCH 3/6] mac80211: fix 1-bit bitfield to unsigned
[PATCH 4/6] mac80211: Fix TSINFO macros endian issue
[PATCH 5/6] mac80211: Fix sparse error for the IEEE802.11e/WMM code
[PATCH 6/6] mac80211: Fix one more sparse error


Thanks,
-yi
