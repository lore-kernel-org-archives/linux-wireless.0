Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2016 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbZBRXuU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 18:50:20 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/8] iwlwifi driver updates 02/18/2009
Date: Wed, 18 Feb 2009 15:54:25 -0800
Message-Id: <1235001273-7808-1-git-send-email-reinette.chatre@intel.com> (sfid-20090219_005025_760700_16845BA4)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series is mostly 3945 porting patches. We include one extra patch
that fixes iwlwifi's DMA access. This patch was posted and discussed
on lkml http://lkml.org/lkml/2009/2/11/306.

[PATCH 1/8] iwl3945: use iwl_rx_scan handlers
[PATCH 2/8] iwl3945: use iwl_mac_hw_scan callback
[PATCH 3/8] iwl3945: use iwl rx handlers
[PATCH 4/8] iwl3945: use iwl_rx_reply_error notification
[PATCH 5/8] iwl3945: remove duplicate interrupt code
[PATCH 6/8] iwl3945: use iwl_isr
[PATCH 7/8] iwl3945: use SW rfkill from iwlwifi
[PATCH 8/8] iwlwifi: dma mapping read and write changes

Thank you

Reinette
