Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41454 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbYJFILt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 04:11:49 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 0/7] iwlwifi driver 10/06 updates
Date: Mon,  6 Oct 2008 16:05:26 +0800
Message-Id: <1223280333-4383-1-git-send-email-yi.zhu@intel.com> (sfid-20081006_101154_826731_132824E8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here are some updates for iwlwifi. Please apply.

Thanks,
-yi

[PATCH 1/7] iwlwifi: make initial calibration set configurable
[PATCH 2/7] iwlwifi: fix ct kill configuration for 5350
[PATCH 3/7] iwlwifi: scan correct setting of valid rx_chains
[PATCH 4/7] iwlwifi: scan fix comment
[PATCH 5/7] iwlwifi: take a valid antenna upon rate scale init
[PATCH 6/7] iwlwifi: remove STATUS_CONF_PENDING in scanning
[PATCH 7/7] iwlwifi: refactor rxon time command
