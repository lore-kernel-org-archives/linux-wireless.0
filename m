Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:21744 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbYCFSlt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 13:41:49 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/2] iwlwifi driver updates
Date: Thu,  6 Mar 2008 10:40:18 -0800
Message-Id: <1204828820-11768-1-git-send-email-reinette.chatre@intel.com> (sfid-20080306_184154_546138_BF29DFC0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These two patches introduce (and start using) a new module
that will be used to contain common code for iwlwifi.

[PATCH 1/2] iwlwifi: add iwl-core module
[PATCH 2/2] iwlwifi: Moving EEPROM handling in iwlcore module

Reinette
