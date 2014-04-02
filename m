Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:42796 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaDBEAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2014 00:00:11 -0400
Received: by mail-pd0-f172.google.com with SMTP id p10so10522976pdj.31
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2014 21:00:10 -0700 (PDT)
From: Fariya Fatima <fariyaf@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Fariya Fatima <fariyaf@gmail.com>
Subject: [PATCH 0/6] rsi: Fixes relating to issues reported by static code analyzers.
Date: Wed,  2 Apr 2014 09:29:49 +0530
Message-Id: <1396411195-5051-1-git-send-email-fariyaf@gmail.com> (sfid-20140402_060016_540430_B1EFEE38)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fariya Fatima <fariyaf@gmail.com>

This series of patches contains fixes relating to issues reported by static code analyzers.

Fariya Fatima (6):
  Potential null pointer derefernce issue fixed.
  Fixed signedness bug reported by static code analyzer.
  Fixed issue relating to variable de-referenced before check 'adapter'
  Fixed issue relating to return value.
  Fixed issue relating to index of q_num.
  Fixed issue relating to doing dma on stack error.

 drivers/net/wireless/rsi/rsi_91x_core.c     |    6 +++-
 drivers/net/wireless/rsi/rsi_91x_debugfs.c  |   35 ++++++++++++--------------
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |    8 ++++--
 drivers/net/wireless/rsi/rsi_91x_sdio.c     |    5 ++-
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |    6 +---
 drivers/net/wireless/rsi/rsi_91x_usb.c      |   26 ++++++++++++++-----
 6 files changed, 49 insertions(+), 37 deletions(-)

-- 
1.7.5.4

