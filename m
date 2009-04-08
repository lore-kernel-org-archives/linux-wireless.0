Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:51935 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755660AbZDHSVE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:21:04 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/18] iwl3945 porting updates
Date: Wed,  8 Apr 2009 11:26:34 -0700
Message-Id: <1239215212-1657-1-git-send-email-reinette.chatre@intel.com> (sfid-20090408_202110_082921_5946EE69)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series continues the work porting 3945 to use iwlcore.
No new functionality is introduced, here we are moving code around
and deleting duplicate code.

[PATCH 01/18] iwl3945: use iwl_bss_info_changed
[PATCH 02/18] iwl3945: use iwl_mac_beacon_update
[PATCH 03/18] iwlwifi: add commit_rxon lib
[PATCH 04/18] iwl3945: delay mode setting
[PATCH 05/18] iwlwifi: add station management ops
[PATCH 06/18] iwl3945: replace station function with station ops
[PATCH 07/18] iwlwifi: use station management ops
[PATCH 08/18] iwl3945/iwlwifi: unify add_station function
[PATCH 09/18] iwl3945: use iwl_get_sta_id from iwlwifi
[PATCH 10/18] iwlwifi: add set_rxon_chain op
[PATCH 11/18] iwl3945: use iwl_set_mode in 3945
[PATCH 12/18] iwl3945: use iwl_mac_add_interface from iwlwifi
[PATCH 13/18] iwl3945: use iwl_mac_remove_interface from iwlwifi
[PATCH 14/18] iwl3945: use iwl_mac_config from iwlwifi
[PATCH 15/18] iwlwifi: add config_ap lib op
[PATCH 16/18] iwl3945: use iwl_mac_config_interface from iwlwifi
[PATCH 17/18] iwl3945: use iwl_mac_get_tx_stats from iwlwifi
[PATCH 18/18] iwl3945: use iwl_mac_reset_tsf from iwlwifi

Thank you

Reinette
