Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:50159 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944AbYEWCLG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 22:11:06 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 00/51] iwlwifi driver 05/23 updates
Date: Fri, 23 May 2008 10:08:38 +0800
Message-Id: <1211508569-3163-1-git-send-email-yi.zhu@intel.com> (sfid-20080523_041112_500004_7BE15448)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here are some iwlwifi drivers update. Please apply.

Thanks,
-yi

[PATCH] iwlwifi: changing irrelevant comment
[PATCH] iwlwifi: remove iwl4965_nic_start function
[PATCH] mac80211: separate Tx and Rx MCS when configuring HT
[PATCH] iwlwifi: filling Tx MCS set
[PATCH] iwlwifi: rename iwl4965_queue to iwl_queue
[PATCH] iwlwifi: rename iwl4965_tx_info to iwl_tx_info
[PATCH] iwlwifi: get_hw_cmd_size
[PATCH] iwlwifi: remove 4965 from iwl4965_tx_queue_update_write_ptr
[PATCH] iwlwifi: remove 4965 prefix from iwl4965_frame
[PATCH] iwlwifi: remove 4965 from iwl4965_rate_info
[PATCH] iwlwifi: move iwl_bcast_addr to iwlcore
[PATCH] iwlwifi: move more station managment into iwl-sta.c
[PATCH] iwlwifi: remove 4956 form iwl4965_tx_cmd
[PATCH] iwlwifi: refactor ieee80211_get_qos_ctrl
[PATCH] iwlwifi: move TX code into iwl-tx.c
[PATCH] iwlwifi: don't switch to SGI if not supported by AP
[PATCH] iwlwifi: clean up and bug fix for security
[PATCH] iwlwifi: rename and move Tx queue activation/deactivation
[PATCH] iwlwifi: add rx_handlers stub for iwl5000
[PATCH] iwlwifi: add ucode loaders for iwl5000
[PATCH] iwlwifi: add ucode init flow handling for iwl5000
[PATCH] iwlwifi: iwl5000 WiFi/WiMax coexistence
[PATCH] iwlwifi: remove 4965 remainings in iwl-eeprom.c file
[PATCH] iwlwifi: add debugfs to disable/enable run time calibration
[PATCH] iwlwifi: refactor pci prob flow
[PATCH] iwlwifi: trigger event log from debugfs
[PATCH] iwlwifi: move iwl_dump_nic_error_log to iwlcore module
[PATCH] iwlwifi: add RTC data address for iwl5000
[PATCH] iwlwifi: use uCode error and event tables pointer w.r.t loaded image
[PATCH] iwlwifi: increase max payload of iwl_cmd
[PATCH] iwlwifi: create drivers debugfs dir under wiphy->debugfsdir
[PATCH] iwlwifi: mark 4965 ucode types
[PATCH] iwlwifi: remove unused variable form __iwl4965_down
[PATCH] iwlwifi: remove notif_missed_beacons variable
[PATCH] iwlwifi: clean up alive_start routine
[PATCH] iwlwifi: remove 4965 from alive_resp structures
[PATCH] iwlwifi: setup correctly L1 L0S pi link values
[PATCH] iwlwifi: implement apm reset flow
[PATCH] iwlwifi: implement apm stop function
[PATCH] iwlwifi: refactor stop master function
[PATCH] iwlwifi: move txq_ctx_stop into iwl-tx.c
[PATCH] iwlwifi: move iwl_rxq_stop into iwl-rx.c
[PATCH] iwlwifi: add remove station functionality
[PATCH] iwlwifi: move add sta handler to iwl-sta.c
[PATCH] iwlwifi: move iwl_rx_missed_beacon_notif to iwl-rx.c
[PATCH] iwlwifi-5000: implement initial calibration for 5000
[PATCH] iwlwifi: activate status ready timeout only for run time ucode
[PATCH] iwlwifi: add iwl5000_tx_response structure
[PATCH] iwlwifi: move tx response common handlers to iwlcore
[PATCH] iwlwifi: impelemnt 5000 tx response path
[PATCH] iwlwifi: move 4965 tx response into iwl-4965.c
