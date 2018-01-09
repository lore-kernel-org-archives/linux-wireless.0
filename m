Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:46282 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751741AbeAINNS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 08:13:18 -0500
Received: by mail-wm0-f68.google.com with SMTP id r78so20429372wme.5
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jan 2018 05:13:18 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] add set_domain routine to reconfigure mt76x2 dfs pd
Date: Tue,  9 Jan 2018 14:13:09 +0100
Message-Id: <cover.1515503003.git.lorenzo.bianconi@redhat.com> (sfid-20180109_141329_580425_9DB035B1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi (3):
  mt76x2: dfs: avoid tasklet scheduling during mt76x2_dfs_init_params()
  mt76x2: dfs: add set_domain handler
  mt76x2: dfs: take into account dfs region in mt76x2_dfs_init_params()

 drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c  | 17 +++++++++++++++--
 drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h  |  2 ++
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c |  2 ++
 4 files changed, 20 insertions(+), 3 deletions(-)

-- 
2.13.6
