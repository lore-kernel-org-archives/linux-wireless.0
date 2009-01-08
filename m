Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4925 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802AbZAHSSW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 13:18:22 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/11] iwlwifi driver updates
Date: Thu,  8 Jan 2009 10:19:51 -0800
Message-Id: <1231438802-10991-1-git-send-email-reinette.chatre@intel.com> (sfid-20090108_191827_531153_1D30981F)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series continues with the cleanup of 3945. It also contains fixes 
for the following bugs:
http://bugzilla.kernel.org/show_bug.cgi?id=11326
  "iwl3945: Error: Response NULL in 'REPLY_ADD_STA', followed by fault"
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1872
  "can not connect with WPA2 enabled AP"
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1873
  "IBSS Cell can be established but can't work, lose more than 50% ping
   packets and scp can't work either"

http://bugzilla.kernel.org/show_bug.cgi?id=12377 appears to be a duplicate
of bug 11326, so patch 7 will fix both.

We also update the copyright year.

[PATCH 01/11] iwl3945: kill hw_params.tx_ant_num
[PATCH 02/11] iwl3945: kill iwl3945_rx_queue_restock
[PATCH 03/11] iwl3945: kill iwl3945_rx_queue_space
[PATCH 04/11] iwl3945: kill iwl3945_x2_queue_used
[PATCH 05/11] iwl3945: remove double defined 3945 tfd structures
[PATCH 06/11] iwl3945: use hw_params.rx_buf_size
[PATCH 07/11] iwlwifi: remove CMD_WANT_SKB flag if send_cmd_sync failure
[PATCH 08/11] iwl3945: Change crypto parameter name
[PATCH 09/11] iwlwifi: Fix get_cmd_string() for REPLY_3945_RX
[PATCH 10/11] iwl3945: Fix iwl3945_init_drv()
[PATCH 11/11] iwlwifi: update copyright year to 2009


Thank you

Reinette
