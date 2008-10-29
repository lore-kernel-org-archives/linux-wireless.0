Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27309 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524AbYJ2VFZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 17:05:25 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/7] iwlwifi driver updates
Date: Wed, 29 Oct 2008 14:05:42 -0700
Message-Id: <1225314349-11139-1-git-send-email-reinette.chatre@intel.com> (sfid-20081029_220532_073383_2766BBD4)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some iwlwifi updates.

[PATCH 1/7] iwlwifi: reorganize flow handler bitology
[PATCH 2/7] iwlwifi: trivial removal of some 4965 remaining from iwl-agn-rs.h
[PATCH 3/7] iwlwifi: fix priv->iw_mode setting when multiple vif are configured
[PATCH 4/7] iwlwifi: rename generic iwlagn functions that had a HW specific name
[PATCH 5/7] iwlwifi: rename double inclusion protection name in iwl-commands.h
[PATCH 6/7] iwlwifi: iwl-agn-rs: initialize rs with valid antenna
[PATCH 7/7] iwlwifi: do not call statistics from rfkill


Thank you

Reinette
