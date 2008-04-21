Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:36491 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926AbYDUWmQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 18:42:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/11] iwlwifi driver updates
Date: Mon, 21 Apr 2008 15:41:50 -0700
Message-Id: <1208817721-11333-1-git-send-email-reinette.chatre@intel.com> (sfid-20080422_004344_577110_A9692018)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains improved power support, a few fixes, and
continues the work on code cleanup and organization.

[PATCH 01/11] iwlwifi: Add power level support
[PATCH 02/11] iwlwifi: changing EEPROM layout handling
[PATCH 03/11] iwlwifi: expanding HW parameters control
[PATCH 04/11] iwlwifi: remove includes to net/ieee80211.h
[PATCH 05/11] iwlwifi: remove uneeded callback
[PATCH 06/11] iwlwifi: remove support for Narrow Channel (10Mhz)
[PATCH 07/11] iwlwifi: fix current channel is not scanned
[PATCH 08/11] iwlwifi: CT-Kill configuration fix
[PATCH 09/11] iwlwifi: support 64 bit DMA masks
[PATCH 10/11] iwlwifi: HT IE in probe request clean up
[PATCH 11/11] iwlwifi: HT antenna/chains overhaul


Thank you

Reinette
