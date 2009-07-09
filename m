Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:49775 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbZGIRdm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 13:33:42 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/6] iwlwifi driver updates 07/09/2009
Date: Thu,  9 Jul 2009 10:33:35 -0700
Message-Id: <1247160821-14989-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

We include two fixes targeting 2.6.31. One is needed for powertop
to be able to parse the sysfs information correctly. The second fix
is needed to be able to transfer fragmented frames in certain
environments. The rest of the series include a security fix and cleanup.

I do not know if patch 3/6 (the security fix) can be considered as 2.6.31
material. It does apply cleanly if you wish to take it.

[PATCH 1/6] iwlwifi: move show_qos to debugfs
[PATCH 2/6 2.6.31 and w-t] iwlwifi: only show active power level via sysfs
[PATCH 3/6] iwlwifi: fix permissions on debugfs files
[PATCH 4/6 2.6.31 and w-t] iwlwifi: only update byte count table during aggregation
[PATCH 5/6] iwl3945: cleanup number of queues settings
[PATCH 6/6] iwlagn: fix minimum number of queues setting

Thank you

Reinette

