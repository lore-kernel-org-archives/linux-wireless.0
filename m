Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:39382 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753078AbdEWPAt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 May 2017 11:00:49 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH v2 0/2] extend mac80211 mesh DFS and CSA functionality
Date: Tue, 23 May 2017 17:00:41 +0200
Message-Id: <20170523150043.22093-1-sw@simonwunderlich.de> (sfid-20170523_170053_135206_49D5DC22)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset includes the remaining two patches for the CSA handling,
with Johannes change suggestions integrated.

Cheers,
     Simon

Simon Wunderlich (2):
  mac80211: mesh: support sending wide bandwidth CSA
  mac80211: enable VHT for mesh channel processing

 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/mesh.c        | 49 +++++++++++++++++++++++++++++++++++++++++++---
 net/mac80211/util.c        | 40 +++++++++++++++++++++++++++++++++++++
 3 files changed, 88 insertions(+), 3 deletions(-)

-- 
2.11.0
