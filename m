Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1107 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbZIYVY2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 17:24:28 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/8] iwlwifi driver updates 09/25/2009
Date: Fri, 25 Sep 2009 14:24:20 -0700
Message-Id: <1253913868-8400-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We include a few fixes targeting 2.6.32 and wireless-testing:
1/8 prevents a WARN printed due to invalid address
2/8 fixes a memory leak
3/8 fixes debug information when a ucode problem occurs in 3945. without
this patch the logs printed when such a problem occurs will be formatted
incorrectly.

The rest of the patches continue adding support for 6000 support as well as
better powersaving support.

[PATCH 1/8 v2.6.32 and w-t] iwlwifi: fix debugfs buffer handling
[PATCH 2/8 v2.6.32 and w-t] iwlwifi: fix memory leak in command queue handling
[PATCH 3/8 v2.6.32 and w-t] iwlwifi: fix 3945 ucode info retrieval after failure
[PATCH 4/8] iwlwifi: fix a typo
[PATCH 5/8] iwlwifi: default to using all chains
[PATCH 6/8] iwlwifi: Chain Noise Calibration for 6000 series
[PATCH 7/8] iwlwifi: support idle for 6000 series hw
[PATCH 8/8] iwlwifi: add module firmware info for 1000 series

Reinette
