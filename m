Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46281 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab1HITvW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 15:51:22 -0400
Received: by gxk21 with SMTP id 21so246333gxk.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 12:51:21 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH 0/6] mac80211: mesh frame formats
Date: Tue,  9 Aug 2011 12:50:12 -0700
Message-Id: <1312919418-32196-1-git-send-email-thomas@cozybit.com> (sfid-20110809_215125_741317_8D9BE114)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Resubmitting all of these since some are now v2/3, and others just really far
down the queue.

Thomas Pedersen (6):
  mac80211: fix mesh beacon format
  ieee80211: introduce Self Protected Action codes
  mac80211: update mesh peering frame codes
  mac80211: update mesh peering frame format
  ieee80211: add mesh action codes
  mac80211: update mesh path selection frame format

 include/linux/ieee80211.h   |   47 +++++----
 net/mac80211/ieee80211_i.h  |    4 +-
 net/mac80211/mesh.c         |  242 +++++++++++++++++++++++++++++++------------
 net/mac80211/mesh.h         |   33 +++++--
 net/mac80211/mesh_hwmp.c    |   59 ++++++-----
 net/mac80211/mesh_pathtbl.c |    8 +-
 net/mac80211/mesh_plink.c   |  238 +++++++++++++++++++++---------------------
 net/mac80211/rx.c           |   23 ++++-
 net/mac80211/tx.c           |   14 ++-
 net/mac80211/util.c         |    6 +-
 10 files changed, 425 insertions(+), 249 deletions(-)

-- 
1.7.6

