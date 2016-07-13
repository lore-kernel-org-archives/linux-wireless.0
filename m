Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([198.47.19.12]:32821 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbcGMLlM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 07:41:12 -0400
From: Yaniv Machani <yanivma@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <johannes@sipsolutions.net>, <netdev@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>, Yaniv Machani <yanivma@ti.com>
Subject: [PATCH v2 0/3] Mesh mpm fixes and enhancements
Date: Wed, 13 Jul 2016 14:44:06 +0300
Message-ID: <20160713114406.24615-1-yanivma@ti.com> (sfid-20160713_134116_790387_A2F63813)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set is addressing some issues found in the current 802.11s implementation, specifically when using hostap mpm. 
It's aligning the beacon format and handling some corner cases.

V2 - Updated patches following review comments.
   - Remove unneccary patches (already upsteamed)

Maital Hahn (1):
  mac80211: mesh: flush stations before beacons are stopped

Yaniv Machani (2):
  mac80211: mesh: improve path resolving time
  mac80211: mesh: fixed HT ies in beacon template

 net/mac80211/mesh.c      | 43 ++++++++++++++++++++++++++++++++++++++-----
 net/mac80211/mesh_hwmp.c | 42 +++++++++++++++++++++++++-----------------
 net/mac80211/util.c      |  3 ---
 3 files changed, 63 insertions(+), 25 deletions(-)

-- 
2.9.0

