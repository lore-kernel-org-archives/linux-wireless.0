Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f68.google.com ([209.85.192.68]:33967 "EHLO
	mail-qg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbcCSCLm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 22:11:42 -0400
Received: by mail-qg0-f68.google.com with SMTP id j92so6595939qgj.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2016 19:11:42 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 0/5] mesh struct cleanups
Date: Fri, 18 Mar 2016 22:11:27 -0400
Message-Id: <1458353492-8654-1-git-send-email-me@bobcopeland.com> (sfid-20160319_031155_737280_FBFBF58A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series makes a few minor mesh cleanups after the rhashtable
rework -- mostly some reductions in padding and allocation waste.

Bob Copeland (5):
  mac80211: mesh: handle failed alloc for rmc cache
  mac80211: mesh: use hlist for rmc cache
  mac80211: mesh: embed gates hlist head directly
  mac80211: mesh: reorder structure members
  mac80211: mesh: fix mesh path kerneldoc

 net/mac80211/mesh.c         | 21 +++++++++++++--------
 net/mac80211/mesh.h         | 31 +++++++++++++++++--------------
 net/mac80211/mesh_pathtbl.c | 18 ++++--------------
 3 files changed, 34 insertions(+), 36 deletions(-)

-- 
2.6.1

