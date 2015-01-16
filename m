Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:64265 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbbAPNNF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 08:13:05 -0500
Received: by mail-wi0-f180.google.com with SMTP id bs8so3751922wib.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 05:13:03 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, antonio@open-mesh.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/2] ath10k: fix 10.2 fw stats
Date: Fri, 16 Jan 2015 14:12:06 +0100
Message-Id: <1421413928-7282-1-git-send-email-michal.kazior@tieto.com> (sfid-20150116_141309_829852_41ABCD38)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've tested this briefly with main 636, 10.1.467,
10.2-00082-4 and 10.2.4.20. However I may have
missed something so I'd be glad if someone can
double-check me :-)


Michal Kazior (2):
  ath10k: split fw pdev stats parsing
  ath10k: fix 10.2 fw stats parsing

 drivers/net/wireless/ath/ath10k/wmi.c | 279 +++++++++++++++++++++++++++-------
 drivers/net/wireless/ath/ath10k/wmi.h | 107 ++++++++++---
 2 files changed, 312 insertions(+), 74 deletions(-)

-- 
1.8.5.3

