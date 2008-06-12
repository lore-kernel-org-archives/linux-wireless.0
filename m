Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbYFLBt2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:49:28 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 00/29] iwlwifi driver 06/12 updates
Date: Thu, 12 Jun 2008 09:46:50 +0800
Message-Id: <1213235239-2954-1-git-send-email-yi.zhu@intel.com> (sfid-20080612_034933_294039_7D8A3F6C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here are the iwlwifi updates on 06/12. Please apply.

Thanks,
-yi

[PATCH 01/29] iwlwifi: removing IWL4965_HT config
[PATCH 02/29] iwlwifi: removes the RUN_TIME_CALIB ifdef
[PATCH 03/29] iwlwifi: clean up in setup/cancel deferred work
[PATCH 04/29] iwlwifi: add possibility to disable tx_power calibration
[PATCH 05/29] iwlwifi: map sw and hw ampdu queues
[PATCH 06/29] iwlwifi: add TX aggregation code for 5000 HW
[PATCH 07/29] iwlwifi: use ieee80211_conf to examine rate capabilities
[PATCH 08/29] iwlwifi: fix allow iwlwifi to aggregate according to tid load
[PATCH 09/29] iwlwifi: remove unused flag
[PATCH 10/29] iwlwifi: remove redundant flags regarding to FAT channel
[PATCH 11/29] iwlwifi: fix bug when moving from 11gn to 11a or 11an to 11g
[PATCH 12/29] iwlwifi: format log prints for easier parsing
[PATCH 13/29] iwlwifi: fix resume SW RF-kill
[PATCH 14/29] iwlwifi: fix resart flow after fw error
[PATCH 15/29] iwlwifi enabling IBSS (Ad-Hoc) mode
[PATCH 16/29] iwlwifi: Fix mode changes (ad-hoc <--> managed)
[PATCH 17/29] iwlwifi: refactor tx aggregation response flow
[PATCH 18/29] iwlwifi: refactor setting tx power
[PATCH 19/29] iwlwifi: add bad length check for WEP keys
[PATCH 20/29] iwlwifi: move scan to iwl-scan.c iwlcore
[PATCH 21/29] iwlwifi: move rate helpers to iwlcore
[PATCH 22/29] iwlwifi: cleans up scanning code
[PATCH 23/29] iwlwifi: move iwl4965_rf_kill_ct_config to iwl-core.c
[PATCH 24/29] iwlwifi: retfactor get_temperature functions
[PATCH 25/29] iwlwifi: remove dead code iwl4965_calc_db_from_ratio
[PATCH 26/29] mac80211 : fix for iwconfig in ad-hoc mode
[PATCH 27/29] iwlwifi: fix software rf_kill problem when interface is down
[PATCH 28/29] iwlwifi: general code clean up
[PATCH 29/29] iwlwifi: remove iwlcore_low_level_notify
