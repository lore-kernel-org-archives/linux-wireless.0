Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:39500 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754251AbeFPP4a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Jun 2018 11:56:30 -0400
Received: by mail-wm0-f66.google.com with SMTP id p11-v6so8502372wmc.4
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jun 2018 08:56:30 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] add dfs sw pattern detector to mt76x2 driver
Date: Sat, 16 Jun 2018 17:56:17 +0200
Message-Id: <20180616155621.30539-1-lorenzo.bianconi@redhat.com> (sfid-20180616_175634_630115_5CC229DA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add sw DFS pattern detector support for mt76x2 based devices.
Dfs pattern supported:
- short pulse radar patterns
- staggered radar patterns

Lorenzo Bianconi (4):
  mt76: introduce mt76_{incr,decr} utility routines
  mt76x2: dfs: add sw event ring buffer
  mt76x2: dfs: add sw pattern detector
  mt76x2: debugfs: add sw pulse statistics to dfs debugfs

 drivers/net/wireless/mediatek/mt76/mt76.h     |  12 +
 .../wireless/mediatek/mt76/mt76x2_debugfs.c   |   8 +
 .../net/wireless/mediatek/mt76/mt76x2_dfs.c   | 378 +++++++++++++++++-
 .../net/wireless/mediatek/mt76/mt76x2_dfs.h   |  60 +++
 4 files changed, 455 insertions(+), 3 deletions(-)

-- 
2.17.1
