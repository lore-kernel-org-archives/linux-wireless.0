Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61291 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbYAWSPW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 13:15:22 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: iwlwifi driver updates
Date: Wed, 23 Jan 2008 10:15:15 -0800
Message-Id: <1201112121-22340-1-git-send-email-reinette.chatre@intel.com> (sfid-20080123_181526_852410_7070CC98)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series containa few updates to the iwlwifi driver.

[PATCH] iwlwifi: Fix an invalid bitmask test in iwl3945 and iwl4965
[PATCH] iwl4965: fix return code indicating one interface is supported
[PATCH] iwlwifi: initialize geo/channel information during probe
[PATCH] iwlwifi: cleanup usage of inline functions
[PATCH] iwlwifi: do not schedule tasklet when rcv unused irq
[PATCH] iwlwifi: Fix uCode error on association


Thank you

Reinette
