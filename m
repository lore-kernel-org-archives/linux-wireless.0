Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52667 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbYE2IhI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:37:08 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 00/43] iwlwifi driver 05/29 updates
Date: Thu, 29 May 2008 16:34:45 +0800
Message-Id: <1212050128-17132-1-git-send-email-yi.zhu@intel.com> (sfid-20080529_103713_548240_23FEAF12)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here are the iwlwifi updates on 05/29. This series is based on the 
wireless-testing GIT commit id 71f33eca536d5aa1ac12a2234d6bea6d4b163d61

mac80211: fix alignment issue with compare_ether_addr()

Patches 01 to 25 are resubmitted (also rebased) for the patches 27~51 on
the 05/23 batch. 26~43 are new.

Thanks,
-yi

[PATCH 01/43] iwlwifi: move iwl_dump_nic_error_log to iwlcore module
[PATCH 02/43] iwlwifi: add RTC data address for iwl5000
[PATCH 03/43] iwlwifi: use uCode error and event tables pointer w.r.t loaded image
[PATCH 04/43] iwlwifi: increase max payload of iwl_cmd
[PATCH 05/43] iwlwifi: create drivers debugfs dir under wiphy->debugfsdir
[PATCH 06/43] iwlwifi: mark 4965 ucode types
[PATCH 07/43] iwlwifi: remove unused variable form __iwl4965_down
[PATCH 08/43] iwlwifi: remove notif_missed_beacons variable
[PATCH 09/43] iwlwifi: clean up alive_start routine
[PATCH 10/43] iwlwifi: remove 4965 from alive_resp structures
[PATCH 11/43] iwlwifi: setup correctly L1 L0S pi link values
[PATCH 12/43] iwlwifi: implement apm reset flow
[PATCH 13/43] iwlwifi: implement apm stop function
[PATCH 14/43] iwlwifi: refactor stop master function
[PATCH 15/43] iwlwifi: move txq_ctx_stop into iwl-tx.c
[PATCH 16/43] iwlwifi: move iwl_rxq_stop into iwl-rx.c
[PATCH 17/43] iwlwifi: add remove station functionality
[PATCH 18/43] iwlwifi: move add sta handler to iwl-sta.c
[PATCH 19/43] iwlwifi: move iwl_rx_missed_beacon_notif to iwl-rx.c
[PATCH 20/43] iwlwifi-5000: implement initial calibration for 5000
[PATCH 21/43] iwlwifi: activate status ready timeout only for run time ucode
[PATCH 22/43] iwlwifi: add iwl5000_tx_response structure
[PATCH 23/43] iwlwifi: move tx response common handlers to iwlcore
[PATCH 24/43] iwlwlifi: impelemnt 5000 tx response path
[PATCH 25/43] iwlwifi: move 4965 tx response into iwl-4965.c
[PATCH 26/43] iwlwifi: fix in-column rate scaling
[PATCH 27/43] iwlwifi: move tx reclaim flow into iwl-tx
[PATCH 28/43] iwlwifi: implement txq invalidate byte count table
[PATCH 29/43] iwlwifi: iwl-5000 add rxon_assoc
[PATCH 30/43] iwlwifi: move iwl_sta_modify_enable_tid_tx to iwl-sta.c
[PATCH 31/43] iwlwifi: move aggregation code to iwl-tx.c
[PATCH 32/43] iwlwifi: add frame count limit to link quality command
[PATCH 33/43] iwlwifi: Rx handlers common use for 4965 and 5000
[PATCH 34/43] iwlwifi: move iwl_get_hw_mode to iwl-core.h
[PATCH 35/43] mac80211: fix ieee80211_get_buffered_bc
[PATCH 36/43] mac80211: fix deadlock in sta->lock
[PATCH 37/43] mac80211: sends HT IE to user level through wext
[PATCH 38/43] mac80211: allow disable FAT in specific configurations
[PATCH 39/43] iwlwifi: disable FAT channel when not permitted
[PATCH 40/43] iwlwifi: fix a memory leak in scan
[PATCH 41/43] iwlwifi: remove debugfs entries before cfg80211
[PATCH 42/43] iwlwifi: send calibration results as HUGE commands
[PATCH 43/43] iwlwifi: clean iwl4965_mac_config
