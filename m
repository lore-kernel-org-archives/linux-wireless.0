Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:16356 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774AbZFSUpc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 16:45:32 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/5] iwlwifi driver updates 6/19/2009
Date: Fri, 19 Jun 2009 13:52:40 -0700
Message-Id: <1245444765-29079-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

General cleanup and the addition of support to be able to scan requested
channels.

[PATCH 1/5] iwlwifi: Check HW ready before prepare card.
[PATCH 2/5] iwlwifi: drop sw_crypto from hw_params.
[PATCH 3/5] iwlwifi: make software queue assignment more efficient
[PATCH 4/5] iwlwifi: scan requested channels only
[PATCH 5/5] iwlwifi: unify iwl_setup_rxon_timing


Reinette
