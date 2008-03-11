Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61044 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbYCKXSL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 19:18:11 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/6] iwlwifi driver updates
Date: Tue, 11 Mar 2008 16:17:14 -0700
Message-Id: <1205277440-14323-1-git-send-email-reinette.chatre@intel.com> (sfid-20080311_231817_473070_2C6612BB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Series contains some fixes as well as changes to move to a shared library
design.

[PATCH 1/6] iwlwifi: fix bug to show hidden APs during scan
[PATCH 2/6] iwlwifi: Use sta_bcast_id variable instead of BROADCAST_ID constant
[PATCH 3/6] iwlwifi: update copyright year
[PATCH 4/6] iwlwifi: Use eeprom form iwlcore
[PATCH 5/6] iwlwifi: Fix endianity in debug print
[PATCH 6/6] iwlwifi: change rate number to a constant


Thank you

Reinette

