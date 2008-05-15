Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47504 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbYEOGCu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 02:02:50 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 00/26] iwlwifi driver 05/15 updates
Date: Thu, 15 May 2008 14:01:19 +0800
Message-Id: <1210831279-3507-1-git-send-email-yi.zhu@intel.com> (sfid-20080515_080256_837623_608A1221)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Please find below iwlwifi driver update for 2.6.26-rc2 wireless-testing.

[PATCH 01/26] iwlwifi: changing irrelevant comment
[PATCH 02/26] iwlwifi: remove iwl4965_nic_start function
[PATCH 03/26] mac80211: separate Tx and Rx MCS when configuring HT
[PATCH 04/26] iwlwifi: filling Tx MCS set
[PATCH 05/26] iwlwifi: rename iwl4965_queue to iwl_queue
[PATCH 06/26] iwlwifi: rename iwl4965_tx_info to iwl_tx_info
[PATCH 07/26] iwlwifi: get_hw_cmd_size
[PATCH 08/26] iwlwifi: remove 4965 from iwl4965_tx_queue_update_write_ptr
[PATCH 09/26] iwlwifi: remove 4965 prefix from iwl4965_frame
[PATCH 10/26] iwlwifi: remove 4965 from iwl4965_rate_info
[PATCH 11/26] iwlwifi: move iwl_bcast_addr to iwlcore
[PATCH 12/26] iwlwifi: move more station managment into iwl-sta.c
[PATCH 13/26] iwlwifi: remove 4956 form iwl4965_tx_cmd
[PATCH 14/26] iwlwifi: refactor ieee80211_get_qos_ctrl
[PATCH 15/26] iwlwifi: move TX code into iwl-tx.c
[PATCH 16/26] iwlwifi: don't switch to SGI if not supported by AP
[PATCH 17/26] iwlwifi: clean up and bug fix for security
[PATCH 18/26] iwlwifi: rename and move Tx queue activation/deactivation
[PATCH 19/26] iwlwifi: add rx_handlers stub for iwl5000
[PATCH 20/26] iwlwifi: add ucode loaders for iwl5000
[PATCH 21/26] iwlwifi: add ucode init flow handling for iwl5000
[PATCH 22/26] iwlwifi: iwl5000 WiFi/WiMax coexistence
[PATCH 23/26] iwlwifi: remove 4965 remainings in iwl-eeprom.c file
[PATCH 24/26] iwlwifi: add debugfs to disable/enable run time calibration
[PATCH 25/26] iwlwifi: refactor pci prob flow
[PATCH 26/26] iwlwifi: trigger event log from debugfs

Thanks,
-yi
