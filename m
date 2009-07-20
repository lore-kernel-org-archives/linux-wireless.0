Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42898 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbZGTDqZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jul 2009 23:46:25 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 00/0] iwmc3200wifi: fix WPA connect problem
Date: Mon, 20 Jul 2009 11:47:42 +0800
Message-Id: <1248061667-8614-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Below patches make iwmc3200wifi WPA work again with the latest cfg80211
change.

[PATCH 1/5] cfg80211: set_default_key only for WEP
[PATCH 2/5] cfg80211: fix typo of IWEVASSOCRESPIE
[PATCH 3/5] iwmc3200wifi: use cfg80211_connect_result to send req/resp IE
[PATCH 4/5] iwmc3200wifi: fix cfg80211_connect_result is called in IBSS
[PATCH 5/5] iwmc3200wifi: fix a use-after-free bug

Thanks,
-yi
