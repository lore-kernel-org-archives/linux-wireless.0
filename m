Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:34793 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756581AbdIHTOI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 15:14:08 -0400
Received: by mail-pg0-f47.google.com with SMTP id q68so6278460pgq.1
        for <linux-wireless@vger.kernel.org>; Fri, 08 Sep 2017 12:14:08 -0700 (PDT)
From: Kevin Cernekee <cernekee@chromium.org>
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com
Cc: brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, mnissler@chromium.org
Subject: [PATCH 0/3] New brcmfmac bounds checks
Date: Fri,  8 Sep 2017 12:13:39 -0700
Message-Id: <20170908191342.28053-1-cernekee@chromium.org> (sfid-20170908_211422_537101_9C5A6EBA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These were suggested by the Chrome OS security team[1].  Compile-tested
only.

[1] http://crosreview.com/656260

Kevin Cernekee (3):
  brcmfmac: Avoid possible out-of-bounds read
  brcmfmac: Don't print out-of-bounds event data
  brcmfmac: Add check for short event packets

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c | 13 +++++++------
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c  |  3 +--
 2 files changed, 8 insertions(+), 8 deletions(-)

-- 
2.14.1.581.gf28d330327-goog
