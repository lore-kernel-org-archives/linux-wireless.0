Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24719 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbZGaV2J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 17:28:09 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/4] iwlwifi driver updates 07/31/2009
Date: Fri, 31 Jul 2009 14:28:05 -0700
Message-Id: <1249075689-8973-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We add support for hardware that can have different power amplifiers. The
rest is cleanup and one fix. The fix is to a problem introduced by a patch
that is not in 2.6.31 so this fix only targets wireless-testing.

[PATCH 1/4] iwlwifi: clear iwl_cmd_meta structure before use
[PATCH 2/4] iwlwifi: Distinguish power amplifier for 6000 series
[PATCH 3/4] iwlwifi: remove deprecated 6000 series adapters
[PATCH 4/4] iwlwifi: remove duplicated version info from sysfs


Thank you

Reinette

