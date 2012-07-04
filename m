Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56387 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab2GDIpX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 04:45:23 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 0/4] 60g support
Date: Wed, 4 Jul 2012 11:45:07 +0300
Message-ID: <1341391511-11359-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120704_104527_866341_1E612AB4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

