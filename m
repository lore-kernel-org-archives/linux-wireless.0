Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35669 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889AbaDBCIO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2014 22:08:14 -0400
Received: by mail-pa0-f52.google.com with SMTP id rd3so10808072pab.11
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2014 19:08:14 -0700 (PDT)
From: Fariya Fatima <fariyaf@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Fariya Fatima <fariyaf@gmail.com>
Subject: [PATCH 0/6] rsi: Fixes related to issues reported by static code analyzers.
Date: Wed,  2 Apr 2014 07:37:59 +0530
Message-Id: <1396404485-3989-1-git-send-email-fariyaf@gmail.com> (sfid-20140402_040817_752552_7981BA5E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fariya Fatima <fariyaf@gmail.com>

This series of patches contains fixes reported by static code analyzers.

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

