Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22570 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbZCREq6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 00:46:58 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/13] iwlwifi driver updates 03/17/2009
Date: Tue, 17 Mar 2009 21:51:40 -0700
Message-Id: <1237351913-19202-1-git-send-email-reinette.chatre@intel.com> (sfid-20090318_054714_570679_F735EBBE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains various fixes, cleanup and extra debugging for
a problems not yet identified.

[PATCH 01/13] iwlagn: use changed in mac_config
[PATCH 02/13] iwl3945: use changed in iwl3945_mac_config
[PATCH 03/13] iwlwifi: return 0 for AMPDU_TX/RX_STOP request if NIC is going down
[PATCH 04/13] iwlagn: allow power level setting all the times
[PATCH 05/13] iwlcore: dont commit power command if interface is not up
[PATCH 06/13] iwlcore: Fix scan problem, resource busy
[PATCH 07/13] iwlwifi: support 11h
[PATCH 08/13] iwl3945: set TFD_QUEUE_MAX to correct value
[PATCH 09/13] iwl3945: use iwl_cmd_queue_free
[PATCH 10/13] iwl3945: fix checkpatch.pl errors
[PATCH 11/13] iwl3945: control rate decrease
[PATCH 12/13] iwlwifi: report error when detect failure during stop agg queue
[PATCH 13/13] iwl3945: replace stations with stations_39


Thank you

Reinette
