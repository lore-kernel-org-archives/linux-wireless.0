Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36702 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab2GELgd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 07:36:33 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v1 0/4] iw: 60g support
Date: Thu, 5 Jul 2012 14:36:17 +0300
Message-ID: <1341488181-12542-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120705_133713_784694_29DA4D07)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

change name for 32-bit bitrate to NL80211_RATE_INFO_BITRATE32

These patches complements 60g infrastructure for the kernel.

It is "low hanging fruits", just fixes what is easy to do.

As for 32-bit bitrate patch, it should bot broke iw with old
kernels, as new attribute will be simply never reported.

Vladimir Kondratiev (4):
  sync nl80211 with kernel v3.5
  Prefer 32-bit bitrate
  introduce GCMP cipher
  Fix print channel number for 60g

 info.c    |    2 +
 link.c    |   10 ++--
 nl80211.h |  180 +++++++++++++++++++++++++++++++++++++++++++------------------
 scan.c    |    3 ++
 station.c |   10 ++--
 util.c    |    8 ++-
 6 files changed, 153 insertions(+), 60 deletions(-)

-- 
1.7.9.5

