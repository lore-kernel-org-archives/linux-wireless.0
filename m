Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2502 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757294Ab3D2Lkd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Apr 2013 07:40:33 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v6] cfg80211: P2P find phase offload
Date: Mon, 29 Apr 2013 14:40:09 +0300
Message-ID: <1367235610-10375-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130429_134038_982845_B8BDF540)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I agree that it is better to require use of P2P interface, i.e.
NL80211_IFTYPE_P2P_DEVICE, for new API. Modified patch to do this.

Also, addressed split() for wiphy get.

>From what I recall, these are all remaining items.

Vladimir Kondratiev (1):
  cfg80211: P2P find phase offload

 include/net/cfg80211.h       |  63 ++++++++++++++++
 include/uapi/linux/nl80211.h |  14 ++++
 net/wireless/nl80211.c       | 167 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |  19 +++++
 net/wireless/trace.h         |  43 +++++++++++
 5 files changed, 306 insertions(+)

-- 
1.8.1.2

