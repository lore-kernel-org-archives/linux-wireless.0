Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22294 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbYICDWs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:22:48 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 0/9 V3] iwlwifi driver fix for 2.6.27
Date: Wed,  3 Sep 2008 11:18:41 +0800
Message-Id: <1220411930-15216-1-git-send-email-yi.zhu@intel.com> (sfid-20080903_052259_178338_F3946699)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Below are 9 patches for 2.6.27. All these fixes have passed our
internal testing/validation. And they affects the iwlwifi driver
only so that won't cause any regression on other components.

Note, although in a patch series, these patches don't have any
dependencies on each other. If you do feel some of them should
not be on this list, please go forward to apply the others. But
I'd suggest you apply them all since they do fix real critical bugs.

Thanks,
-yi

[PATCH 1/9] iwlwifi: W/A for the TSF correction in IBSS
[PATCH 2/9] iwlwifi: fix hidden ssid discovery in passive channels
[PATCH 3/9] iwlwifi: remove false rxon if rx chain changes
[PATCH 4/9] iwlwifi: generic init calibrations framework
[PATCH 5/9] iwlwifi: fix station mimo power save values
[PATCH 6/9] iwlwifi: fix rx_chain computation
[PATCH 7/9] iwlwifi: fix Tx cmd memory allocation failure handling
[PATCH 8/9] iwlwifi: call apm stop on exit
[PATCH 9/9] iwlwifi: fix STATUS_EXIT_PENDING is not set on pci_remove
