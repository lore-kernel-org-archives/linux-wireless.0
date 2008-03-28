Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:23691 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401AbYC1XZZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 19:25:25 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 0/8] iwlwifi driver updates including one mac80211 change
Date: Fri, 28 Mar 2008 16:21:04 -0700
Message-Id: <1206746472-10443-1-git-send-email-reinette.chatre@intel.com> (sfid-20080328_232529_278268_4341E04E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains bug fixes as well as new rfkill features.

The series includes on patch to mac80211 that enables a driver to
send status events to mac. This patch also changes iwlwifi to make
use of this new feature.

[PATCH 1/8] iwlwifi: add notification infrastructure to iwlcore
[PATCH 2/8] iwlwifi: hook iwlwifi with Linux rfkill
[PATCH 3/8] mac80211: enable driver to notify mac of status, change iwlwifi
[PATCH 4/8] iwlwifi: fix race condition during driver unload
[PATCH 5/8] iwlwifi: move rate registration to module load
[PATCH 6/8] iwlwifi: unregister to upper stack before releasing resources
[PATCH 7/8] iwlwifi: LED initialize before registering
[PATCH 8/8] iwlwifi: Fix synchronous host command


Thank you

Reinette

