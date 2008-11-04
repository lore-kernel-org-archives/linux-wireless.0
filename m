Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:39826 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375AbYKDUVQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 15:21:16 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/3] iwlwifi driver fixes: wireless-testing and 2.6.28
Date: Tue,  4 Nov 2008 12:21:33 -0800
Message-Id: <1225830096-7052-1-git-send-email-reinette.chatre@intel.com> (sfid-20081104_212121_437047_E4E7701B)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

This series contains three fixes for the iwl3945 driver.
All three patches also apply to 2.6.28, could you please
apply them to 2.6.28 also?

The fix for the deadlock in suspend has already been made
for iwlagn and sent to 2.6.28.

The fix for the scanning bits have already been made for
iwlagn in wireless-testing, could you please send that 
patch to 2.6.28 also? It is:
iwlwifi: clear scanning bits upon failure
9685e33a2c919c1e95cb7072988fc1e0f0bad3d9

The fix for the channel count is not needed for iwlagn.

[PATCH 1/3] iwl3945: clear scanning bits upon failure
[PATCH 2/3] iwl3945: do not send scan command if channel count zero
[PATCH 3/3] iwl3945: fix deadlock on suspend

Thank you very much

Reinette

