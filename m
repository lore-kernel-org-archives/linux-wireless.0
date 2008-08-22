Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12033 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317AbYHVB7P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 21:59:15 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2.6.27 0/3] iwlwifi driver fix for 2.6.27 08/22
Date: Fri, 22 Aug 2008 09:55:37 +0800
Message-Id: <1219370140-21481-1-git-send-email-yi.zhu@intel.com> (sfid-20080822_035920_189875_17FCB007)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Below 3 patches are critical fixes for iwlwifi driver on 2.6.27. Please
apply.

[PATCH 1/3] iwlwifi: fix apm_stop function
[PATCH 2/3] iwlwifi: generic init calibrations framework
[PATCH 3/3] iwlwifi: call apm stop on exit

Thanks,
-yi
