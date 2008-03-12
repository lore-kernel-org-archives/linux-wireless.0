Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:51341 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbYCMAEF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 20:04:05 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/5] iwlwifi driver updates
Date: Wed, 12 Mar 2008 16:58:47 -0700
Message-Id: <1205366332-12652-1-git-send-email-reinette.chatre@intel.com> (sfid-20080313_000414_074311_55B36D09)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains some bug fixes, more changes to move to a shared
library, and debugfs support.

[PATCH 1/5] iwlwifi: Bug fix, CCMP with HW encryption with AGG
[PATCH 2/5] iwlwifi: rename iwl-4965-debug.h back to iwl-debug.h
[PATCH 3/5] iwlwifi: rename struct iwl4965_priv to struct iwl_priv
[PATCH 4/5] iwlwifi: Add TX/RX statistcs to driver
[PATCH 5/5] iwlwifi: Add debugfs to iwl core


Thank you

Reinette
