Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:40055 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755909AbZBJXPU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 18:15:20 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/3] iwlwifi driver updates 02/10/2009
Date: Tue, 10 Feb 2009 15:19:01 -0800
Message-Id: <1234307944-21820-1-git-send-email-reinette.chatre@intel.com> (sfid-20090211_001530_566900_D802B202)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Two cleanups and a fix to configure 5000 series FAT channels correctly.

[PATCH 1/3] iwlwifi: use pci registers defined in pci_regs.h
[PATCH 2/3] iwlwifi: drop PCIe workaround applicable for development boards
[PATCH 3/3] iwlwifi: fix FAT channel config for 5000 series

Thank you

Reinette
