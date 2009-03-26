Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51901 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbZCZRIm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 13:08:42 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/3] iwlwifi driver updates 03/26/2009
Date: Thu, 26 Mar 2009 10:14:07 -0700
Message-Id: <1238087650-26993-1-git-send-email-reinette.chatre@intel.com> (sfid-20090326_180845_964296_09ECFB38)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this series we improve support for suspend/resume by making use of
infrastructure already in place in mac80211. We fix the problem where
device cannot come back up if rfkill was enabled during ifdown. The 3945
is a porting patch but through this also fixes a locking issue that was
present in iwl3945 but not in iwlagn (see
https://bugzilla.redhat.com/show_bug.cgi?id=492116).

[PATCH 1/3] iwlwifi: merge and better support of suspend/resume for iwlagn and iwl3945
[PATCH 2/3] iwlwifi: remove STATUS_ALIVE checking from rf_kill
[PATCH 3/3] iwl3945: use iwl_mac_conf_tx


Thank you

Reinette

