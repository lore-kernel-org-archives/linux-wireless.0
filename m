Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:30954 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbYDXAPK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 20:15:10 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/16] iwlwifi driver updates
Date: Wed, 23 Apr 2008 17:14:52 -0700
Message-Id: <1208996108-15326-1-git-send-email-reinette.chatre@intel.com> (sfid-20080424_021602_145141_5673B029)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series continues the reorganization work on iwlwifi driver. We also
include a few fixes.

[PATCH 01/16] iwlwifi: add apm init handler
[PATCH 02/16] iwlwifi: add iwl_hw_detect function to iwl core
[PATCH 03/16] iwlwifi: check eeprom version in pci probe time
[PATCH 04/16] iwlwifi: handle shared memory
[PATCH 05/16] iwlwifi: TLC modifications
[PATCH 06/16] iwlwifi: rate scale module cleanups
[PATCH 07/16] iwlwifi: rate scale restructure toggle_antenna functions
[PATCH 08/16] iwlwifi: reorganize TX RX constatns
[PATCH 09/16] iwlwifi: rs fix wrong parenthesizing in rs_get_lower_rate function
[PATCH 10/16] iwlwifi: rate sacaling fixes
[PATCH 11/16] iwlwifi: more RS improvements
[PATCH 12/16] iwlwifi: clean up register names and defines
[PATCH 13/16] iwlwifi: unify init driver flow
[PATCH 14/16] iwlwifi: iwl-sta redundant includes clean up
[PATCH 15/16] iwlwifi: move Flow Handlers define to iwl-fh.h
[PATCH 16/16] iwlwifi: 3945 remove unused SCD definitions

Thank you

Reinette

