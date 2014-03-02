Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:60185 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbaCBJVP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Mar 2014 04:21:15 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 0/2] wil6210: fixes for issues found by smatch
Date: Sun, 2 Mar 2014 11:20:49 +0200
Message-ID: <1393752051-7611-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140302_102211_726810_360B5A94)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch found 2 issues, one real off-by-one causing buffer
overflow, and one minor warning. Fixing both.

Vladimir Kondratiev (2):
  wil6210: fix buffer overflow in wil_txdesc_debugfs_show()
  wil6210: fix smatch warning in wil_cfg80211_get_station()

 drivers/net/wireless/ath/wil6210/cfg80211.c |  2 +-
 drivers/net/wireless/ath/wil6210/debugfs.c  | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

-- 
1.8.3.2

