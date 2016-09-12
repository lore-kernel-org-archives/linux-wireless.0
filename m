Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36733 "EHLO
        mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751449AbcILJmU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 05:42:20 -0400
Received: by mail-pa0-f50.google.com with SMTP id id6so49341245pad.3
        for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2016 02:42:20 -0700 (PDT)
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        johannes.berg@intel.com, hofrat@osadl.org
Cc: prameela.j04cs@gmail.com, prameela.garnepudi@redpinesignals.com
Subject: [PATCH 0/9] rsi: code clean-up
Date: Mon, 12 Sep 2016 15:08:15 +0530
Message-Id: <cover.1473669618.git.prameela.j04cs@gmail.com> (sfid-20160912_114223_915038_C6681315)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

*** BLURB HERE ***

Prameela Rani Garnepudi (9):
  rsi: cleanup and added debug prints in file rsi_91x_core.c
  rsi: Spelling and code format corrections in rsi_91x_debugfs.c
  rsi: Added freeing of allocated buffers (sbands and dfsentry)         
    Cleanup (spelling mistakes, code format corrections,     	     
    empty lines after declaration)
  rsi: code clean up in file rsi_91x_main.c
  rsi: code cleanup in file rsi_91x_mgmt.c
  rsi: code cleanup (spelling mistakes and new line after declaration)
    in file rsi_91x_sdio.c          Added developer name
  rsi: zone changed for debug message and cleanup in file
    rsi_91x_sdio_ops.c
  rsi: code clean up and replaced ctrl message timeouts with macros in
    file rsi_91x_usb.c
  rsi: code cleanup in file rsi_91x_usb_ops.c

 drivers/net/wireless/rsi/rsi_91x_core.c     | 24 +++++++++++++----
 drivers/net/wireless/rsi/rsi_91x_debugfs.c  | 13 ++++-----
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 24 ++++++++++++-----
 drivers/net/wireless/rsi/rsi_91x_main.c     | 16 +++++------
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 30 +++++++++++----------
 drivers/net/wireless/rsi/rsi_91x_sdio.c     | 16 +++++------
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |  6 ++---
 drivers/net/wireless/rsi/rsi_91x_usb.c      | 42 ++++++++++++++++-------------
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c  |  9 +++----
 9 files changed, 104 insertions(+), 76 deletions(-)

-- 
2.4.11
