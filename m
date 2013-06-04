Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:58173 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab3FDPEL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 11:04:11 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v9] P2P find phase offload
Date: Tue, 4 Jun 2013 18:03:10 +0300
Message-ID: <1370358191-7103-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130604_170414_083585_5F1CC95D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- add listen_channel
- comment on channel set assumption (either missing or non-empty set)
- document expected behavior for p2p_find conflict with scan/ROC
- document probe/probe-resp reporting assumption
- remove check for genlmsg_end return value

Vladimir Kondratiev (1):
  cfg80211: P2P find phase offload

 include/net/cfg80211.h       |  72 +++++++++++++++++
 include/uapi/linux/nl80211.h |  15 ++++
 net/wireless/nl80211.c       | 181 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |  19 +++++
 net/wireless/trace.h         |  42 ++++++++++
 5 files changed, 329 insertions(+)

-- 
1.8.1.2

