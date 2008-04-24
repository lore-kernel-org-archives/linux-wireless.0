Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6916 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757409AbYDXSzo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 14:55:44 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/21] iwlwifi updates to enable 5000 family
Date: Thu, 24 Apr 2008 11:55:17 -0700
Message-Id: <1209063338-6572-1-git-send-email-reinette.chatre@intel.com> (sfid-20080424_205620_108326_72C2DF2C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains more general iwlwifi changes to support
more hardware. It also includes our first series of patches to
add support for the Intel Wifi Link 5000 family.

[PATCH 01/21] iwlwifi: move verify_ucode functions to iwl-core
[PATCH 02/21] iwlwifi: remove 49 prefix from general CSR values
[PATCH 03/21] iwlwifi: move hw_rx_handler_setup to iwl-4965.c
[PATCH 04/21] iwlwifi: remove unnecessary apmg settings
[PATCH 05/21] iwlwifi: wrapping nic configuration in iwl core handler
[PATCH 06/21] iwlwifi-5000: adding initial recognition for the 5000 family
[PATCH 07/21] iwlwifi-5000: add ops infrastructure for 5000
[PATCH 08/21] iwlwifi-5000: add apm_init handler for 5000 HW family
[PATCH 09/21] iwlwifi-5000: use iwl4965_set_pwr_src in 5000
[PATCH 10/21] iwlwifi-5000: EEPROM settings for 5000
[PATCH 11/21] iwlwifi-5000: adding iwl5000 HW parameters
[PATCH 12/21] iwlwifi-5000: update the CT-Kill value for 5000 series
[PATCH 13/21] iwlwifi-5000: add run time calibrations for 5000
[PATCH 14/21] iwlwifi-5000: adjust antennas names in 5000 HW family
[PATCH 15/21] iwlwifi-5000: Add HW REV of 5000 HW family
[PATCH 16/21] iwlwifi-5000: add iwl 5000 shared memory handlers
[PATCH 17/21] iwlwifi-5000: update the byte count in SCD
[PATCH 18/21] iwlwifi-5000: add eeprom check version handler
[PATCH 19/21] iwlwifi-5000: add nic config handler for 5000 HW
[PATCH 20/21] iwlwifi: rename iwl-4965-commands to iwl-commands.h
[PATCH 21/21] iwlwifi: rename iwl-4965.h to iwl-dev.h


Thank you

Reinette

