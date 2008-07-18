Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:54091 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbYGRF4Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 01:56:16 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 00/13] iwlwifi driver 07/18 updates
Date: Fri, 18 Jul 2008 13:52:56 +0800
Message-Id: <1216360389-5352-1-git-send-email-yi.zhu@intel.com> (sfid-20080718_075624_538420_6F289A85)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This patch series adds power save for 5000 hardware and misc cleanup.

Thanks,
-yi

[PATCH 01/13] iwlwifi: add power save to 5000 HW
[PATCH 02/13] iwlwifi: corrects power_level in sysfs
[PATCH 03/13] mac80211: pass dtim_period to low level driver
[PATCH 04/13] mac80211: make listen_interval be limited by low level driver
[PATCH 05/13] iwlwifi: use dtim_period from association, and set listen_interval
[PATCH 06/13] iwlwifi: move iwl4965_mac_ampdu_action to iwl4965-base.c
[PATCH 07/13] iwlwifi: move beacon handling to iwl4965-base.c
[PATCH 08/13] iwlwifi: move iwl4965_set_pwr_src to iwl4965-base.c
[PATCH 09/13] iwlwifi: rename iwl-4695-rs to iwl-agn-rs
[PATCH 10/13] iwlwifi: kill iwl4965_fill_rs_info
[PATCH 11/13] iwlwifi: set led register in disassociation
[PATCH 12/13] mac80211: remove unused variable agg_queue
[PATCH 13/13] iwlwifi: bug fix in AGG flow - cast const to ULL
