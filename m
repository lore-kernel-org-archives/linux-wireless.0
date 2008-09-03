Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41622 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbYICDa4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:30:56 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 00/39] iwlwifi driver 09/03 updates
Date: Wed,  3 Sep 2008 11:26:20 +0800
Message-Id: <1220412419-15404-1-git-send-email-yi.zhu@intel.com> (sfid-20080903_053059_656487_9E2A4B01)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Below are iwlwifi patches (1 for mac80211 and 1 for ath9k) against
wireless-testing GIT tip. Patches 01 ~ 11 are resubmitted.

Thanks,
-yi

[PATCH 01/39] iwlwifi : Added bss_info_changed callback to 3945
[PATCH 02/39] iwlwifi: W/A for the TSF correction in IBSS
[PATCH 03/39] iwlwifi: clean up hw scan handler
[PATCH 04/39] iwlwifi: remove obsolete 4965 forward declarations
[PATCH 05/39] iwlwifi: allow consecutive scans in unassociated state
[PATCH 06/39] iwlwifi: align set channel with mac80211
[PATCH 07/39] iwl3945: fix unbalanced mutex
[PATCH 08/39] iwl3945: replace association and beacon hooks with bss_info_changed cb
[PATCH 09/39] iwlwifi: fix hidden ssid discovery in passive channels
[PATCH 10/39] iwl3945: removed bg_post_associate work
[PATCH 11/39] iwl3945: avoid redundant iwl3945_get_active_dwell_time
[PATCH 12/39] iwlwifi: use strict_strtoul instead of simple_strtoul
[PATCH 13/39] iwlwifi: void full rxon on rx chain changes
[PATCH 14/39] iwlwifi: replace readl and writel with io/read/write/32
[PATCH 15/39] iwlwifi: remove rfkill warning from iwl-io
[PATCH 16/39] iwlwifi: fix apm_stop function
[PATCH 17/39] iwlwifi: generic init calibrations framework
[PATCH 18/39] iwlwifi: call apm stop on exit
[PATCH 19/39] iwlwifi: fix strict_strtoul error checking
[PATCH 20/39] iwlwifi: use station's mimo power save values
[PATCH 21/39] iwlwifi: fix rx_chain computation
[PATCH 22/39] iwlwifi: fix 64bit platform firmware loading
[PATCH 23/39] mac80211: change MIMO_PS to SM_PS
[PATCH 24/39] iwlwifi: change MIMO_PS to SM_PS
[PATCH 25/39] ath9k: change MIMO_PS to SM_PS
[PATCH 26/39] iwlwifi: remove double definition of SM PS
[PATCH 27/39] iwlwifi: rename ps_mode to sm_ps
[PATCH 28/39] iwlwifi: workaround interrupt handling no some platforms
[PATCH 29/39] iwlwifi: cleanup PCI register handling
[PATCH 30/39] iwlwifi: allow association on radar channel in power save
[PATCH 31/39] iwlwifi: fix memory allocation of TX command
[PATCH 32/39] iwlwifi: fix host command header according the HW spec
[PATCH 33/39] iwlwifi: use the results from disconnected antenna algorithm
[PATCH 34/39] iwlwifi: take a fresh set of supported rates at each cycle
[PATCH 35/39] iwlwifi: remove bad language from the comments
[PATCH 36/39] iwlwifi: remove uneeded declarations
[PATCH 37/39] iwlwifi: fix compile warning
[PATCH 38/39] iwl3945: enable active scanning on active channels
[PATCH 39/39] iwlwifi: enable packet injection for iwlagn
