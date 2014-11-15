Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33218 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbaKOTGe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2014 14:06:34 -0500
Received: by mail-pa0-f50.google.com with SMTP id eu11so19586956pac.37
        for <linux-wireless@vger.kernel.org>; Sat, 15 Nov 2014 11:06:33 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH 0/2] ath9k|ath9k_htc: Allow Software Crypto for Transmitted Management Frame in mesh
Date: Sun, 16 Nov 2014 03:05:39 +0800
Message-Id: <1416078341-4411-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20141115_201537_744286_6228C97C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches enable the software encryption to be done in
software for transmitted management frame for USB devices,
especially for secured mesh.

Chun-Yeow Yeoh (2):
  ath9k|ath9k_htc: Seperate the software crypto flag for Tx and Rx
  ath9k_htc: Enable software crypto for mgmt frame in Tx for USB devices

 drivers/net/wireless/ath/ath9k/common.c       |  2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |  2 +-
 drivers/net/wireless/ath/ath9k/hw.c           | 12 +++++++++---
 drivers/net/wireless/ath/ath9k/hw.h           |  3 ++-
 drivers/net/wireless/ath/ath9k/main.c         |  2 +-
 5 files changed, 14 insertions(+), 7 deletions(-)

-- 
2.1.1

