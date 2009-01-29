Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:55862 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068AbZA2TGU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 14:06:20 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/7] iwlwifi driver updates 01/29/2009
Date: Thu, 29 Jan 2009 11:09:10 -0800
Message-Id: <1233256157-21290-1-git-send-email-reinette.chatre@intel.com> (sfid-20090129_200624_910393_51EC0BF0)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains updates to iwlwifi for support of new hardware.

We also include one Kconfig patch for ipw2x00 to fix a display
problem.

[PATCH 1/7] iwlwifi: add new HW_REV_TYPEs for Intel WiFi Link 100, 6000 and 6050 Series
[PATCH 2/7] iwlwifi: simplify parameter setting to allow support for 6000 series
[PATCH 3/7] iwlwifi: parametrize configuration of the PLL for exclusion on 6000
[PATCH 4/7] iwlwifi: correct API command overlap
[PATCH 5/7] iwlwifi: define structures and functions externally for customization
[PATCH 6/7] iwlwifi: remove chain noise calibration functions from 6000 family
[PATCH 7/7] ipw2x00: correct Kconfig to prevent following entries from not indenting


Thank you

Reinette
