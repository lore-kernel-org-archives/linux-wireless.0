Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26186 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589AbYGTXkW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2008 19:40:22 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] Introducing IWLAGN
Date: Mon, 21 Jul 2008 02:40:12 +0300
Message-Id: <1216597215-19708-1-git-send-email-tomas.winkler@intel.com> (sfid-20080721_014026_319733_E49BCEB0)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of patches renames iwl4965 driver to iwlagn driver
The driver supports both 4965AGN NIC and 5000AGN NICs family
 
The driver binary module meanwhile retains its original iwl4965.ko name
for not breaking the old stuff but it will be eventually renamed
for the upcoming linux stable version to iwlagn.ko.
Any suggestions on timing this are welcome.

Thanks
Tomas


---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

