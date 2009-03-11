Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20115 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbZCKSM7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 14:12:59 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/8] iwlwifi driver updates 03/11/2009
Date: Wed, 11 Mar 2009 11:17:53 -0700
Message-Id: <1236795481-12757-1-git-send-email-reinette.chatre@intel.com> (sfid-20090311_191304_269754_3B269297)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this series we have a few 3945 patches. They are mostly fixes and one
patch that continues the 3945 port to use iwlcore. We also include a fix
when using WEP and some patches providing extra information for users when
driver encounters a problem.

[PATCH 1/8] iwl3945: fix sparse error
[PATCH 2/8] iwl3945: use iwl_led structure
[PATCH 3/8] iwl3945 : fix rate scaling
[PATCH 4/8] iwl3945: use iwl_tx_cmd_complete
[PATCH 5/8] iwl3945: unmap previously mapped memory
[PATCH 6/8] iwlagn: fix warning when set WEP key
[PATCH 7/8] iwlwifi: print contents of control register when error occurs
[PATCH 8/8] iwlwifi: correct log level when error occurs


Thank you

Reinette

