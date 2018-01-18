Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:42348 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932379AbeARXIU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 18:08:20 -0500
Received: by mail-wm0-f68.google.com with SMTP id b141so81203wme.1
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jan 2018 15:08:19 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] disable all pending tasklets during device removal
Date: Fri, 19 Jan 2018 00:08:12 +0100
Message-Id: <cover.1516315624.git.lorenzo.bianconi@redhat.com> (sfid-20180119_000824_345763_86EA3733)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset is based on 'add set_domain routine to reconfigure
mt76x2 dfs pd' patchset

Lorenzo Bianconi (2):
  mt76x2: init: disable tbtt tasklet during device cleanup
  mt76x2: dfs: disable dfs tasklet during device cleanup

 drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c  | 6 ++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h  | 1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c | 2 ++
 3 files changed, 9 insertions(+)

-- 
2.13.6
