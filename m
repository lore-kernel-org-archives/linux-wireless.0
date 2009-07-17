Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:12884 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934733AbZGQQa3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 12:30:29 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/14] iwlwifi driver updates 07/17/2009
Date: Fri, 17 Jul 2009 09:30:13 -0700
Message-Id: <1247848227-24031-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains something of everything. We include some general fixes
(new hardware stability, log output corrections, correct data used to compute led
 blinking rate, better error detection, including better handling of
 failures during ucode loading) and general cleanup. Some new
features include the addition of code to deal with a new ucode header
format that includes a build number. This new ucode header format is
currently only used for new hardware for which the ucode is not public yet.
We also include a new debugfs file to show led status and include a revamp
of the debug interface.

We include a bugfix for http://bugzilla.kernel.org/show_bug.cgi?id=13742
which targets wireless-testing and 2.6.31.

[PATCH 01/14] iwlagn: modify digital SVR for 1000
[PATCH 02/14] iwlwifi: fix rx signal quality reporting in dmesg
[PATCH 03/14] iwlwifi: Handle new firmware file with ucode build number in header
[PATCH 04/14] iwlwifi: make led functions generic
[PATCH 05/14 w-t and 2.6.31] iwlagn: do not send key clear commands when rfkill enabled
[PATCH 06/14] iwlwifi: add led debugfs function
[PATCH 07/14] iwlwifi: Led blinking counting both tx and rx
[PATCH 08/14] iwlwifi: checking unknown HW type
[PATCH 09/14] iwlwifi: update 1000 series API version to match firmware
[PATCH 10/14] iwlwifi: uCode Alive notification with timeout
[PATCH 11/14] iwlwifi: make debug level more user friendly
[PATCH 12/14] iwlwifi: clarify hardware error message
[PATCH 13/14] iwlwifi: inform user about rfkill state changes
[PATCH 14/14] iwlwifi: change iwl_enable/disable_interrupts to "inline"


Reinette

