Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:55498 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbZHCGf1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 02:35:27 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 00/0] iwmc3200wifi 802.1X fixes
Date: Mon,  3 Aug 2009 14:37:00 +0800
Message-Id: <1249281423-26435-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The below patches fix iwmc3200wifi for IEEE 802.1X with WEP.

[PATCH 1/3] iwmc3200wifi: fix set_wpa_version and set_auth_type order
[PATCH 2/3] iwmc3200wifi: set WEP key static flag correctly
[PATCH 3/3] iwmc3200wifi: avoid setting default key for 802.1X and RSNA

Thanks,
-yi
