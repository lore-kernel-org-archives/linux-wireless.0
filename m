Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:60992 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbYAOC0y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2008 21:26:54 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 00/12] iwlwifi driver updates
Date: Mon, 14 Jan 2008 17:46:13 -0800
Message-Id: <1200361585-31801-1-git-send-email-reinette.chatre@intel.com> (sfid-20080115_022701_714642_C2C68B14)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains various fixes and improvements to the iwlwifi driver.
It applies to wireless-2.6#everything.

[PATCH 01/12] iwl4965: Remove redundant code in iwl4965_tx_cmd
[PATCH 02/12] iwlwifi: move iwl4965_get_dma_hi_address function to iwl-helpers.h
[PATCH 03/12] iwlwifi: remove iwl4965_tx_cmd
[PATCH 04/12] iwlwifi: document scan command
[PATCH 05/12] iwlwifi: delay firmware loading from pci_probe to network interface open
[PATCH 06/12] iwlwifi: fix problem when rf_killswitch change during suspend/resume
[PATCH 07/12] iwlwifi: move uCode helper functions to iwl-helpers.h
[PATCH 08/12] iwlwifi: 4965 unify rate scale variable names for station data
[PATCH 09/12] iwlwifi: 3954 renames iwl3945_rate_scale_priv to iwl3945_rs_sta
[PATCH 10/12] iwlwifi: Update iwlwifi version stamp to 1.2.23
[PATCH 11/12] iwlwifi: remove reference to non-existent documentation
[PATCH 12/12] iwlwifi: style fixes to usage of << and >> operators


Thank you

Reinette

