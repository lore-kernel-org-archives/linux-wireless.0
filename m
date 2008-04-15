Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56235 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbYDOXCG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 19:02:06 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/11] iwlwifi driver updates
Date: Tue, 15 Apr 2008 16:01:36 -0700
Message-Id: <1208300507-25628-1-git-send-email-reinette.chatre@intel.com> (sfid-20080416_000220_220671_DE2A3C3F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains various iwlwifi updates and two bugfixes (#8 and #10).

[PATCH 01/11] iwlwifi: remove the statistics work
[PATCH 02/11] iwlwifi: hw_setting cleanup
[PATCH 03/11] iwlwifi: support different num of tx and rx antennas
[PATCH 04/11] iwlwifi: move the creation of LQ host command to iwlcore
[PATCH 05/11] iwlwifi: move HW device registration
[PATCH 06/11] iwlwifi: introduce host commands callbacks
[PATCH 07/11] iwlwifi: move rxon associated command to hcmd
[PATCH 08/11] iwlwifi: Fix TKIP update key and get_free_ucode_key
[PATCH 09/11] iwlwifi: arrange max number of Tx queues
[PATCH 10/11] iwlwifi: fix unload warning and error
[PATCH 11/11] iwlwifi: Use HW acceleration decryption by default

Thank you

Reinette
