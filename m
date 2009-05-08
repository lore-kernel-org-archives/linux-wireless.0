Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:47912 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755885AbZEHUiU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 16:38:20 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/11] iwlwifi driver updates 05/08/2009
Date: Fri,  8 May 2009 13:44:35 -0700
Message-Id: <1241815486-13510-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

We include fixes and cleanup. With the new restart work that relies on
mac80211 a connection can recover with minimal distruption after a ucode
SYSASSERT. PS received attention with cleanup and fixes. Rate scaling
improvements are also included. We now make more debugging information
available via debugfs and sysfs.

One patch adds new device ids for devices already supported by driver. This
same patch also contains a fix as these devices were previously configured
incorrectly. Could you please include this patch into 2.6.30 and
wireless-testing?

[PATCH 01/11] iwlwifi: do proper hw restart
[PATCH 02/11] iwlwifi: fix PS disable status race
[PATCH 03/11] iwlwifi: clean up PS code
[PATCH 04/11] iwlagn: improve rate scale table search
[PATCH 05/11] iwlwifi: more descriptive unsupported hardware message
[PATCH 06/11] iwl3945: read rev id in nic config
[PATCH 07/11] iwlwifi: use #define instead of hard coded value
[PATCH 08/11] iwlagn: show current rate scale data in debugfs
[PATCH 09/11] iwlwifi: show qos AC parameters
[PATCH 10/11] iwlwifi: default WMM AC parameters
[PATCH 11/11 v2.6.30 and w-t] iwlwifi: fix device id registration for 6000 series 2x2 devices


Thank you

Reinette

