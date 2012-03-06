Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23627 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031267Ab2CFWn1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 17:43:27 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/33] update for 3.4: iwlwifi 2012-03-06
Date: Tue,  6 Mar 2012 13:30:35 -0800
Message-Id: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120306_234331_507581_A84D147E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Second set of major re-factor and clenup works happen in iwlwifi,
we move the code to the proper place and get ready for the next generation
of the devices


Johannes Berg (33):
  iwlwifi: move ucode loading to op_mode
  iwlwifi: split out firmware store
  iwlwifi: remove iwl-wifi.h
  iwlwifi: add wrappers for command sending
  iwlwifi: move RF/CT kill check to command wrapper
  iwlwifi: move lockdep assertion into DVM
  iwlwifi: move mutex out of shared
  iwlwifi: move rfkill status handling out of transport
  iwlwifi: rename ucode.h to fw-file.h
  iwlwifi: remove AMT check from transport
  iwlwifi: remove shadow_reg_enable from hw_params
  iwlwifi: move status check functions out of shared
  iwlwifi: make tracing use device as identifier
  iwlwifi: virtualize command queue full behaviour
  iwlwifi: clean up iwl-core.h inclusions
  iwlwifi: remove num_of_queues module parameter
  iwlwifi: remove max_txq_num from hw_params
  iwlwifi: keep plcp_delta_threshold in priv
  iwlwifi: use watchdog timeout from hw_params
  iwlwifi: put use_rts_for_aggregation into hw_params
  iwlwifi: constify remaining config data
  iwlwifi: fix notification wait bug
  iwlwifi: abstract out notification wait support
  iwlwifi: move ucode_owner to priv
  iwlwifi: move all uCode load variables
  iwlwifi: move irq to PCIe
  iwlwifi: move packet to transport
  iwlwifi: virtualize nic_config
  iwlwifi: remove priv from shared
  iwlwifi: remove PA type configuration
  iwlwifi: don't include iwl-prph.h everywhere
  iwlwifi: clean up iwl-commands.h
  iwlwifi: make iwl_fill_probe_req static


these patches are also available from wireless-next branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git
