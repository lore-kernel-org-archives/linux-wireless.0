Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:47921 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292AbZGPJdJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 05:33:09 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 00/09] iwmc3200wifi updates
Date: Thu, 16 Jul 2009 17:34:05 +0800
Message-Id: <1247736854-6760-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here are some patches for iwmc3200wifi driver to adapt to recent
cfg80211 changes.

[PATCH 01/09] iwmc3200wifi: fix UMAC INIT_COMPLETE notification handling
[PATCH 02/09] iwmc3200wifi: hardware does not support IP checksum
[PATCH 03/09] iwmc3200wifi: set cipher_suites before registering wiphy
[PATCH 04/09] iwmc3200wifi: use correct debug level
[PATCH 05/09] iwmc3200wifi: cfg80211 managed mode port
[PATCH 06/09] iwmc3200wifi: remove setting WEP keys before setting essid support
[PATCH 07/09] iwmc3200wifi: make iwm_send_wifi_if_cmd return 0 on success
[PATCH 08/09] iwmc3200wifi: remove key caches in driver
[PATCH 09/09] cfg80211: remove WARN_ON in __cfg80211_sme_scan_done

Thanks,
-yi
