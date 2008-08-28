Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43471 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbYH1J3H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 05:29:07 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 00/11] iwlwifi driver fixes for 2.6.27
Date: Thu, 28 Aug 2008 17:24:59 +0800
Message-Id: <1219915510-3647-1-git-send-email-yi.zhu@intel.com> (sfid-20080828_112911_951937_5D111D19)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here are the iwlwifi patches vital for 2.6.27. Please apply.

Thanks,
-yi

[PATCH 01/11] iwlwifi: W/A for the TSF correction in IBSS
[PATCH 02/11] iwlwifi: use mac80211 band and channel settings
[PATCH 03/11] iwlwifi: fix hidden ssid discovery in passive channels
[PATCH 04/11] iwlwifi: remove false rxon if rx chain changes
[PATCH 05/11] iwlwifi: workaround interrupt handling no some platforms
[PATCH 06/11] iwlwifi: fix apm_stop
[PATCH 07/11] iwlwifi: generic init calibrations framework
[PATCH 08/11] iwlwifi: call apm stop on exit
[PATCH 09/11] iwlwifi: fix station mimo power save values
[PATCH 10/11] iwlwifi: fix rx_chain computation
[PATCH 11/11] iwlwifi: fix 64bit platform firmware loading
