Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25545 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757337AbZEVRzL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2009 13:55:11 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/10] iwlwifi driver updates 05/22/2009
Date: Fri, 22 May 2009 11:01:45 -0700
Message-Id: <1243015315-13848-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


We include support for later hardware which uses OTP instead of EEPROM.
This series also addresses issues with iwlwifi register locking by
improving it with a special register lock combined with more reliable nic
access. The 5000 and later hardware support ICT interrupts, which are now
supported. We also include a few fixes required for support of ICT
interrupt.

Later platforms have AMT enabled by default - we include a patch to enable
hardware to work on these platforms.

[PATCH 01/10] iwlwifi: support NVM access (EEPROM/OTP)
[PATCH 02/10] iwlcore: register locks
[PATCH 03/10] iwlwifi: report the rate index as an MCS rate number
[PATCH 04/10] iwlwifi: support "pure 40MHz" in RXON command
[PATCH 05/10] iwlcore: support ICT interrupt
[PATCH 06/10] iwlcore: Allow skb allocation from tasklet.
[PATCH 07/10] iwlcore: Add support for periodic RX interrupt
[PATCH 08/10] iwlcore: Set rb_timeout to 0x10 for devices with ICT
[PATCH 09/10] iwlagn: co-exist with AMT
[PATCH 10/10] iwlwifi: check for valid band for channel info


Thank you

Reinette
