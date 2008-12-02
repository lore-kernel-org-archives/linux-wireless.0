Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:37010 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbYLBUNL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 15:13:11 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/11] iwlwifi driver updates
Date: Tue,  2 Dec 2008 12:13:56 -0800
Message-Id: <1228248847-10424-1-git-send-email-reinette.chatre@intel.com> (sfid-20081202_211316_218139_36B4B6A8)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains a few cleanups and fixes. The fixes address the
following problems:
- failure of HW crypto in 3945 (patch 3)
- 3945 rate scaling (patch 7)
- significant delay when bringing interface down (patch 8)
- A band association in passive channels (patch 11)

The series also contains a new feature that enables support of older
firmware versions (patches 9 and 10).

[PATCH 01/11] iwlwifi: move host command check function into separate file
[PATCH 02/11] iwlwifi: fix printk size format error
[PATCH 03/11] iwl3945: Select correct sta ID from find_station()
[PATCH 04/11] iwlwifi: move disable/enable interrupts to iwl-core.c
[PATCH 05/11] iwlwifi: move channels sysfs to debugfs
[PATCH 06/11] iwl3945: add debugfs support
[PATCH 07/11] iwl3945: Fix iwl3945 rate scaling.
[PATCH 08/11] iwlwifi: fix DMA channel number in iwl_txq_ctx_stop
[PATCH 09/11] iwlwifi: store ucode version number
[PATCH 10/11] iwlwifi: rely on API version read from firmware
[PATCH 11/11] iwl3945 : Fix a-band association for passive channels


Thank you

Reinette
