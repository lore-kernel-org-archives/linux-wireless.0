Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:39728 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751799AbdLNMDc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 07:03:32 -0500
Received: by mail-wm0-f67.google.com with SMTP id i11so10904360wmf.4
        for <linux-wireless@vger.kernel.org>; Thu, 14 Dec 2017 04:03:31 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: dan.carpenter@oracle.com, linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] Fix two possible NULL pointer dereferencing issues
Date: Thu, 14 Dec 2017 13:03:15 +0100
Message-Id: <cover.1513252573.git.lorenzo.bianconi@redhat.com> (sfid-20171214_130336_801181_DFFB6BD8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi (2):
  mt76: fix possible NULL pointer dereferencing in mt76x2_ampdu_action()
  mt76: fix possible NULL pointer dereferencing in
    mt76x2_mac_write_txwi()

 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c  | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

-- 
2.13.6
