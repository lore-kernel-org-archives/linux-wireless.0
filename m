Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61539 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbYLEP5o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 10:57:44 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/6] iwlwifi driver updates
Date: Fri,  5 Dec 2008 07:58:35 -0800
Message-Id: <1228492721-27381-1-git-send-email-reinette.chatre@intel.com> (sfid-20081205_165752_470431_6D0D03A1)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains a few cleanups and the following fixes:
- patch 2 continues work on 3945 rate scaling
- patch 4 fixes the "MAC in deep sleep" problem that was reported in 
http://marc.info/?l=linux-wireless&m=122729668410075&w=2 and also tracked
in http://bugzilla.kernel.org/show_bug.cgi?id=11818 and
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1834
- patch 5 continues work on the latency issue when bringing down the
interface. This problem is tracked in
http://bugzilla.kernel.org/show_bug.cgi?id=11956 and
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1790

[PATCH 1/6] iwlwifi: implement iwl_debug_report_frame for iwlagn
[PATCH 2/6] iwl3945: Fix rate scale for B-mode connection
[PATCH 3/6] iwlwifi: fix time interval misuse in iwl_poll_{direct_}bit
[PATCH 4/6] iwlwifi: fix "MAC in deep sleep" error
[PATCH 5/6] iwlwifi: iwl_poll_{direct_}bit cleanup
[PATCH 6/6] iwlwifi: use rmb/wmb to protect indirect mmio operation


Thank you

Reinette

