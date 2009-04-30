Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:17738 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbZD3UuP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 16:50:15 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/5] iwlwifi driver updates 04/30/2009
Date: Thu, 30 Apr 2009 13:56:25 -0700
Message-Id: <1241124991-12492-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this series we change the locking in the 3945 RX path to
increase the likelihood for allocation to succeed by enabling GFP_KERNEL
allocation instead of GFP_ATOMIC. We disable PS support temporarily until
some issues with it are resolved. We also include some cleanup.

We include one patch that addresses a problem tracked by kerneloops.org.
For this fix we provide a patch that applies to wireless-testing and a
second patch that applies to linux-2.6.

[PATCH 1/5] iwl3945: fix lock dependency
[PATCH 2/5] iwlagn: disable PS support for iwlagn
[PATCH 3/5] iwlwifi: "is_fat" bit in rate scale match RXON flag
[PATCH 4/5] iwlwifi: replace test_and_set_bit by set_bit in clear stations function
[PATCH 5/5] iwlwifi: update key flags at time key is set
[PATCH 1/1 v2.6.30] iwlwifi: update key flags at time key is set


Thank you

Reinette

