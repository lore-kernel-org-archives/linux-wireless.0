Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23612 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbZGXSNO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 14:13:14 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/14] iwlwifi driver updates 07/24/2009
Date: Fri, 24 Jul 2009 11:12:59 -0700
Message-Id: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this series we introduce a new thermal throttling feature that places
NIC in a lower power state with fewer activities when temperature reaches
particular thresholds. We also include two fixes, one addresses a TX queue
race between driver and mac80211 and the other fixes a null pointer access
introduced by an earlier patch (which is not in 2.6.31). The TX queue race
problem is present in v2.6.31 so we include a patch for that kernel also.
The rest of this series is cleanup.

[PATCH 01/14] iwlwifi: revert to active table when rate is not valid
[PATCH 02/14] iwlwifi: critical temperature enter/exit condition
[PATCH 03/14] iwlwifi: Thermal Throttling Management - Part 1
[PATCH 04/14] iwlwifi: Thermal Throttling Management - part 2
[PATCH 05/14] iwlwifi: Thermal Throttling debugfs function
[PATCH 06/14] iwlwifi: fix up command sending
[PATCH 07/14] iwlwifi: remove command callback return value
[PATCH 08/14] iwlwifi: fix TX queue race
[PATCH 09/14] iwlwifi: print packet contents in error case
[PATCH 10/14] iwlwifi: Name fix for MPDU density for TX aggregation
[PATCH 11/14] iwlwifi: fix LED config option
[PATCH 12/14] iwlwifi: debugFs to enable/disable 40MHz channel support
[PATCH 13/14] iwlagn: fix null pointer access during ucode load on 1000
[PATCH 14/14] iwlagn: fix sparse warning when compiling without debug

[PATCH v2.6.31] iwlwifi: fix TX queue race

Thank you

Reinette
