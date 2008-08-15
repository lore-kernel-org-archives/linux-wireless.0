Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17686 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbYHOCEl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 22:04:41 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 00/15] iwlwifi driver 08/15 updates
Date: Fri, 15 Aug 2008 10:01:05 +0800
Message-Id: <1218765680-8378-1-git-send-email-yi.zhu@intel.com> (sfid-20080815_040448_840431_FCD10218)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here are some fix and cleanup for iwlwifi and mac80211.  Note mac80211
patches 07~10 are already submitted by Tomas Winkler before.

Thanks,
-yi

[PATCH 01/15] iwlwifi: Added bss_info_changed callback to 3945
[PATCH 02/15] iwlwifi: W/A for the TSF correction in IBSS
[PATCH 03/15] iwlwifi: clean up hw scan handler
[PATCH 04/15] iwlwifi: remove obsolete 4965 forward declarations
[PATCH 05/15] iwlwifi: allow consecutive scans in unassociated state
[PATCH 06/15] iwlwifi: align set channel with mac80211
[PATCH 07/15] mac80211: filter probes in ieee80211_rx_mgmt_probe_resp
[PATCH 08/15] mac80211: cleanup mlme state namespace
[PATCH 09/15] mac80211: change number of pre-assoc scans
[PATCH 10/15] mac80211: add direct probe before association
[PATCH 11/15] iwl3945: fix unbalanced mutex
[PATCH 12/15] iwl3945: replace association and beacon hooks with bss_info_changed cb
[PATCH 13/15] iwlwifi: fix hidden ssid discovery in passive channels
[PATCH 14/15] iwl3945: removed bg_post_associate work
[PATCH 15/15] iwl3945: avoid redundant iwl3945_get_active_dwell_time
