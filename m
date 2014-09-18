Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:54392 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaIRNf4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2014 09:35:56 -0400
Received: by mail-wg0-f46.google.com with SMTP id n12so905981wgh.29
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2014 06:35:55 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/3] ath10k: debug improvements
Date: Thu, 18 Sep 2014 15:25:18 +0200
Message-Id: <1411046721-20510-1-git-send-email-michal.kazior@tieto.com> (sfid-20140918_153600_079387_4A86312D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This adds extra prints and information for
debugging purposes.


Michal Kazior (3):
  ath10k: print wmi version info
  ath10k: dump hex bytes with dev string prefix
  ath10k: add debug dump for pci rx

 drivers/net/wireless/ath/ath10k/debug.c | 29 ++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/pci.c   |  6 ++++++
 2 files changed, 32 insertions(+), 3 deletions(-)

-- 
1.8.5.3

