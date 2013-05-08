Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:13143 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab3EHITa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 04:19:30 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v7] P2P find phase offload
Date: Wed, 8 May 2013 11:19:07 +0300
Message-ID: <1368001148-3619-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130508_101942_613221_44F1D964)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Addressed input for previous version:
- formatting
- defaults for p2p params accordingly to the spec
- clarify driver should notify cfg80211 about find phase end
  in case stop_p2p_find was requested by cfg80211

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

