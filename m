Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16352 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbYKLVNr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 16:13:47 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/8] iwlwifi driver updates
Date: Wed, 12 Nov 2008 13:14:03 -0800
Message-Id: <1226524451-3417-1-git-send-email-reinette.chatre@intel.com> (sfid-20081112_221350_329478_7479DA22)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mostly code cleanup. The exception is "iwlwifi: configure_filter rewrite"
that better maps the mac80211 and iwlwifi hardware filter flags.

[PATCH 1/8] iwl3945 : Simplify iwl3945_pci_probe
[PATCH 2/8] iwlwifi: consolidate station management code
[PATCH 3/8] iwlwifi: rs: remove fc variable and other cleanups
[PATCH 4/8] iwlwifi: replace magic constants with define
[PATCH 5/8] iwlwifi : fix checkpatch.pl errors
[PATCH 6/8] iwlwifi: configure_filter rewrite
[PATCH 7/8] iwlwifi: some fh document fix and cleanup
[PATCH 8/8] iwlwifi: iwl-fh.h cleanup

Thank you

Reinette
