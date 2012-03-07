Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20333 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758076Ab2CGTG1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 14:06:27 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/35] update for 3.4: iwlwifi 2012-03-07
Date: Wed,  7 Mar 2012 09:52:09 -0800
Message-Id: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120307_200631_935991_4C25D194)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Third set of major re-factor and clenup works happen in iwlwifi,
we move the code to the proper place and get ready for the next generation
of the devices


Amit Beka (2):
  iwlwifi: fixed testmode notifications length
  iwlwifi: add testmode command for rx forwarding

David Spinadel (1):
  iwlwifi: add option to test MFP

Don Fry (3):
  iwlwifi: separate status to priv and trans
  iwlwifi: more status bit factoring
  iwlwifi: correct status bit refactoring errors

Emmanuel Grumbach (2):
  iwlwifi: log stop / wake queues
  iwlwifi: restore PAN support

Johannes Berg (17):
  iwlwifi: remove unused arguments from iwlagn_gain_computation
  iwlwifi: remove unused argument from rs_initialize_lq
  iwlwifi: move iwl_sta_id_or_broadcast to user
  iwlwifi: remove unused argument from iwl_init_hw_rates
  iwlwifi: remove two unused arguments in testmode
  iwlwifi: remove unused argument from iwlagn_suspend
  iwlwifi: redesign PASSIVE_NO_RX workaround
  iwlwifi: transport's tx_agg_disable must be atomic
  iwlwifi: remove BT handlers from lib_ops
  iwlwifi: move BT/HT params to shared
  iwlwifi: make EEPROM enhanced TX power a bool
  iwlwifi: remove unused max_nrg_cck from sensitivity and constify
  iwlwifi: return error if loading uCode failed
  iwlwifi: remove messages from queue wake/stop
  iwlwifi: make iwl_init_context static
  iwlwifi: don't delete AP station directly
  iwlwifi: always monitor for stuck queues

Meenakshi Venkataraman (3):
  iwlwifi: configure transport layer from dvm op mode
  iwlwifi: move setting up fw parameters
  iwlwifi: move command queue number out of the iwl_shared struct

Stanislaw Gruszka (7):
  iwlwifi: dump stack when fail to gain access to the device
  iwlwifi: always check if got h/w access before write
  iwlwifi: cleanup/fix memory barriers
  iwlwifi: use writeb,writel,readl directly
  iwlwifi: print DMA stop timeout error only if it happened
  iwlwifi: reintroduce iwl_enable_rfkill_int
  iwlwifi: make tx_cmd_pool kmem cache global

these patches are also available from wireless-next branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

