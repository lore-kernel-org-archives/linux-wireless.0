Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42648 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbZFLUPv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 16:15:51 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/8 2.6.31 and w-t] iwlwifi driver updates 06/12/2009
Date: Fri, 12 Jun 2009 13:22:47 -0700
Message-Id: <1244838175-15491-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We include a few bugfixes for 2.6.31 and additional changes that target
2.6.32. Here we have a few fixes for pure 40Mhz mode. We also fix a
bug that caused a few errors when you suspend/resume while being association.
The rest of the patches improve behavior of 5150 device and more cleanup.

[PATCH 1/8 v2.6.31 and w-t ] iwlwifi: revamp bss_info_changed
[PATCH 2/8 v2.6.31 and w-t ] iwlwifi: checking for 40MHz mode
[PATCH 3/8 v2.6.31 and w-t ] iwlwifi: check control channel for pure 40MHz
[PATCH 4/8 v2.6.31 and w-t ] iwlwifi: check for channel location for 40MHz
[PATCH 5/8 v2.6.31 and w-t ] iwlwifi/iwl3945: fix suspend resume association bug
[PATCH 6/8] iwlwifi: modify sensitivity value for 5150
[PATCH 7/8] iwlwifi: no need to refer to max_nrg_cck range value
[PATCH 8/8] iwlwifi: remove disable_tx_power for device > 4965


Reinette
