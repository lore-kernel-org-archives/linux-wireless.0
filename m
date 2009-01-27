Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7077 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbZA0WZH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 17:25:07 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/7] iwlwifi driver updates 01/27/2009
Date: Tue, 27 Jan 2009 14:27:51 -0800
Message-Id: <1233095278-5850-1-git-send-email-reinette.chatre@intel.com> (sfid-20090127_232512_633193_F4A5A55A)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains two patches towards the 3945 porting effort (patch 1
and patch 7). We include a few driver fixes identified by sparse.

Patch 5 is a very big patch that changes code not to use implicit
variables. I hope it does not cause any problems for you.

Patch 6 adds some code back that went missing between 2.6.28 and
2.6.29-rc1. The cause of this problem has not been identified so we hope
that this is the only problem of this kind.

[PATCH 1/7] iwl3945: Getting rid of the *39_rxon iwl_priv fields
[PATCH 2/7] iwlwifi: suppress unused variable warning when compiling w/o IWLWIFI_DEBUG
[PATCH 3/7] iwlwifi: iwl3945_send_tx_power must be static
[PATCH 4/7] iwlwifi: check return value of pci_enable_device
[PATCH 5/7] iwlwifi: don't use implicit priv in IWL_DEBUG
[PATCH 6/7] iwlwifi: clean key table in iwl_clear_stations_table
[PATCH 7/7] iwlwifi: unify iwlagn and 3945 power save management


Thank you

Reinette

