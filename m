Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4799 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbYJNTfZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 15:35:25 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/9] iwlwifi driver updates
Date: Tue, 14 Oct 2008 12:32:40 -0700
Message-Id: <1224012769-8920-1-git-send-email-reinette.chatre@intel.com> (sfid-20081014_213530_843027_47540AB9)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contain updates for iwlwifi drivers. 
Patch 8 is a rework of Johannes's patch titled 
"iwlwifi: fix DMA code and bugs". We do not have the hardware to ensure the
problem is fixed and would thus appreciate feedback.

[PATCH 1/3] iwlwifi: define firmware file name once
[PATCH 2/3] iwlwifi: expand error lookup and align output
[PATCH 3/3] iwlwifi: remove host commands structures from iwl_cmd
[PATCH 4/9] iwlwifi: add iwl_cmd_queue_free for readability
[PATCH 5/9] iwlwifi: unify tx antenna toggling
[PATCH 6/9] iwlwifi: refactor TX response flow
[PATCH 7/9] iwl3945 : Fix a-band association for passive channels
[PATCH 8/9] iwlwifi: fix TX cmd dma unmapping
[PATCH 9/9] iwlwifi: tx command must run on same tfd as packet


Thank you

Reinette

