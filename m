Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:52353 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751544AbeBHWIU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Feb 2018 17:08:20 -0500
Received: by mail-wm0-f67.google.com with SMTP id g1so12107961wmg.2
        for <linux-wireless@vger.kernel.org>; Thu, 08 Feb 2018 14:08:19 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: kubakici@wp.pl
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] mt7601u: update mac addr if different from eeprom one
Date: Thu,  8 Feb 2018 23:08:07 +0100
Message-Id: <cover.1518126991.git.lorenzo.bianconi@redhat.com> (sfid-20180208_230826_189610_14122EB3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi (2):
  mt7601u: move mt7601u_set_macaddr in mac related code
  mt7601u: set device mac address in mt7601u_add_interface()

 drivers/net/wireless/mediatek/mt7601u/eeprom.c | 24 ++----------------------
 drivers/net/wireless/mediatek/mt7601u/mac.c    | 16 ++++++++++++++++
 drivers/net/wireless/mediatek/mt7601u/mac.h    |  1 +
 drivers/net/wireless/mediatek/mt7601u/main.c   |  3 +++
 4 files changed, 22 insertions(+), 22 deletions(-)

-- 
2.14.3
