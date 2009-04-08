Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9750 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932251AbZDHSdo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 14:33:44 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/6] iwlwifi driver updates 04/08/2009
Date: Wed,  8 Apr 2009 11:39:26 -0700
Message-Id: <1239215972-1795-1-git-send-email-reinette.chatre@intel.com> (sfid-20090408_203402_177788_08900BB8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some iwlwifi fixes as well as additional debugging for rate scaling
and interrupt handling.

This series should be applied after the 3945 porting series as patch 3/6
depends on 1/18 from that series.

[PATCH 1/6] iwlwifi: Display decoded rate/mcs information
[PATCH 2/6] iwlwifi: do not set dual_stream_ant_msk for 3 streams
[PATCH 3/6] iwlagn: Sync rxon active with changes
[PATCH 4/6] iwlwifi: check triple_stream_basic_rates in iwl_full_rxon_required
[PATCH 5/6] iwlcore: fix channel display in debugfs
[PATCH 6/6] iwlwifi: adding interrupt counter in debugfs for debugging


Thank you

Reinette

