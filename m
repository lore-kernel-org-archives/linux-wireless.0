Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:59795 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbZAUFba (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 00:31:30 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/5] iwlwifi driver updates 01/20/2009
Date: Tue, 20 Jan 2009 21:33:50 -0800
Message-Id: <1232516035-25524-1-git-send-email-reinette.chatre@intel.com> (sfid-20090121_063155_847692_A77D0FAF)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains three fixes to iwlwifi rate scaling. Of most interest is
a fix for the "rs_get_rate()" problem that is tracked on kerneloops.org. A
similar fix that applies to 2.6.29 will be sent separately.

We also include a fix for the "MAC is in deep sleep" problem tracked in 
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1845 and
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1834

We include one 3945 porting patch.

[PATCH 1/5] iwlwifi: fix rs_get_rate WARN_ON()
[PATCH 2/5] iwlwifi: allow user to set max rate
[PATCH 3/5] iwlagn: fix agn rate scaling
[PATCH 4/5] iwl3945: Use iwl-rfkill
[PATCH 5/5] iwl3945: fix deep sleep when removing the driver.


Thank you 

Reinette
