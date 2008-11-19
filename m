Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:64646 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190AbYKSXb4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 18:31:56 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/7] iwlwifi driver updates
Date: Wed, 19 Nov 2008 15:32:21 -0800
Message-Id: <1227137548-28718-1-git-send-email-reinette.chatre@intel.com> (sfid-20081120_003215_708214_3D1D2E33)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series contains mostly fixes for iwlwifi. Patch 7 is a fix to a bug
that is tracked as a regression from 2.6.27
(http://bugzilla.kernel.org/show_bug.cgi?id=12040 ). The patch does apply
to Linus's tree also - could you please push this patch there?

[PATCH 1/7] iwl3945 : Fix ad-hoc mode for 3945
[PATCH 2/7] iwlwifi: move iwl_clear_stations_table to iwl-sta.c
[PATCH 3/7] iwlwifi: enable base band calibration in 5000 HW
[PATCH 4/7] iwlwifi: 4965 define firmware file name once
[PATCH 5/7] iwlwifi: TX setup fix confusion between TX queue and TX DMA channel
[PATCH 6/7] iwlwifi: TX update chicken bits
[PATCH 7/7] iwlwifi: prevent double key removal

Thank you

Reinette
