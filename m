Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13154 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593AbZB1AQt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 19:16:49 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/6] iwlwifi driver updates 02/27/2009
Date: Fri, 27 Feb 2009 16:21:18 -0800
Message-Id: <1235780484-27979-1-git-send-email-reinette.chatre@intel.com> (sfid-20090228_011656_370603_F5E19FE8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains mostly 3945 porting patches. We include one fix in the
probe function's error flow. The API version of uCode for new hardware is
updated, backport support already present.

[PATCH 1/6] iwlwifi: update 5150 API version to support new firmware
[PATCH 2/6] iwl3945: synchronize timestamp with uCode
[PATCH 3/6] iwl3945: unify set key flow with iwlwifi
[PATCH 4/6] iwlwifi: fix *pci_probe error flow
[PATCH 5/6] iwl3945: add iwl3945_setup_mac
[PATCH 6/6] iwl3945 : use iwl_activate_qos


Thank you

Reinette

