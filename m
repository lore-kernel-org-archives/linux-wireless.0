Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:31244 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbYKGR6N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 12:58:13 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/13] iwlwifi driver updates
Date: Fri,  7 Nov 2008 09:58:33 -0800
Message-Id: <1226080726-24860-1-git-send-email-reinette.chatre@intel.com> (sfid-20081107_185819_155984_AA40F9D2)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains iwlwifi (iwlagn and iwl3945) updates.

[PATCH 01/13] iwlagn: fix resume for ADHOC network
[PATCH 02/13] iwl3945: fix resume for ADHOC network
[PATCH 03/13] iwlwifi: trivial fix in includes
[PATCH 04/13] iwlwifi: don't fail power set when calibration is not done yet
[PATCH 05/13] iwlwifi: update iwl-commands.h for 3 stream support
[PATCH 06/13] iwlwifi: move rx queue read pointer into rxq
[PATCH 07/13] iwlwifi: revamp tx scheduler byte count tables handling
[PATCH 08/13] iwlwifi: move spectrum measurement code to iwl-spectrum.c file
[PATCH 09/13] iwl3945 : Fix Sparse Warnings
[PATCH 10/13] iwlwifi: move iwl_print_hex_dump to iwl-debug.h
[PATCH 11/13] iwl3945 : Simplify iwl3945_send_beacon_cmd
[PATCH 12/13] iwlwifi: get some more information about command failure
[PATCH 13/13] iwlwifi: use Rx single frame mode (one Rx frame per RB)


Thank you

Reinette

