Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42816 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932415AbeGIKUg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jul 2018 06:20:36 -0400
Received: by mail-wr1-f68.google.com with SMTP id p1-v6so10375210wrs.9
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2018 03:20:36 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: kubakici@wp.pl
Cc: linux-wireless@vger.kernel.org, dcaratti@redhat.com
Subject: [PATCH 0/2] enable 802.11w in mt7601u driver
Date: Mon,  9 Jul 2018 12:20:25 +0200
Message-Id: <cover.1531130155.git.lorenzo.bianconi@redhat.com> (sfid-20180709_122040_019141_7003CD74)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi (1):
  mt7601u: use sw encryption for hw unsupported ciphers

Davide Caratti (1):
  mt7601u: expose 802.11w support

 drivers/net/wireless/mediatek/mt7601u/init.c |  1 +
 drivers/net/wireless/mediatek/mt7601u/main.c | 11 +++++++++++
 2 files changed, 12 insertions(+)

-- 
2.17.1
