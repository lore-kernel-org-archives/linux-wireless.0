Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:18724 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab3FDGop (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 02:44:45 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v8] P2P find phase offload
Date: Tue, 4 Jun 2013 09:44:30 +0300
Message-ID: <1370328271-9523-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130604_084448_461804_C53703A7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- Fix kerneldoc for start_p2p_find/stop_p2p_find (forgotten '@')
- rebase

Vladimir Kondratiev (1):
  cfg80211: P2P find phase offload

 include/net/cfg80211.h       |  65 ++++++++++++++++
 include/uapi/linux/nl80211.h |  13 ++++
 net/wireless/nl80211.c       | 175 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |  19 +++++
 net/wireless/trace.h         |  42 +++++++++++
 5 files changed, 314 insertions(+)

-- 
1.8.1.2

