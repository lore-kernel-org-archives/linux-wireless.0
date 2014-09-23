Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:44991 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbaIWIdi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 04:33:38 -0400
Received: by mail-we0-f178.google.com with SMTP id t60so4133332wes.23
        for <linux-wireless@vger.kernel.org>; Tue, 23 Sep 2014 01:33:37 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/3] ath10k: debug improvements
Date: Tue, 23 Sep 2014 10:22:51 +0200
Message-Id: <1411460574-5424-1-git-send-email-michal.kazior@tieto.com> (sfid-20140923_103352_978247_A364CDB9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This adds extra prints and information for
debugging purposes.


v2:
 * merge scnprintfs

Michal Kazior (3):
  ath10k: print wmi version info
  ath10k: dump hex bytes with dev string prefix
  ath10k: add debug dump for pci rx

 drivers/net/wireless/ath/ath10k/debug.c | 25 ++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/pci.c   |  6 ++++++
 2 files changed, 28 insertions(+), 3 deletions(-)

-- 
1.8.5.3

