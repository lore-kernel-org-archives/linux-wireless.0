Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4746 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755733AbYGABXa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 21:23:30 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH-2.6.26 00/2] iwlwifi driver patches for 2.6.26
Date: Tue,  1 Jul 2008 09:20:32 +0800
Message-Id: <1214875234-23567-1-git-send-email-yi.zhu@intel.com> (sfid-20080701_032336_563898_16BE042D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The below two patches are already in wireless-next-2.6. I think they
should be merged into 2.6.26 tree as well.

[PATCH-2.6.26 1/2] iwlwifi: fix incorrect 5GHz rates reported in monitor mode
[PATCH-2.6.26 2/2] iwlwifi: drop skb silently for Tx request in monitor mode

Thanks,
-yi
