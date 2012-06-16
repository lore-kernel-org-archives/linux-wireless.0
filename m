Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34554 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab2FPTbz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2012 15:31:55 -0400
Received: by wibhj8 with SMTP id hj8so669034wib.1
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jun 2012 12:31:54 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 0/3] wl1251 filtering fixes
Date: Sat, 16 Jun 2012 22:31:47 +0300
Message-Id: <1339875110-10260-1-git-send-email-notasas@gmail.com> (sfid-20120616_213158_582018_F7D8CB7A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These paches handle some wl1251 filtering issues that seem to fix some
connection drop issues. These changes have been tested on Pandora units
by several users with positive results.

Grazvydas Ignotas (3):
  wl1251: remove unused filter_work
  wl1251: fix filtering support
  wl1251: send filters to firmware as they are set

 drivers/net/wireless/ti/wl1251/cmd.c    |    9 ----
 drivers/net/wireless/ti/wl1251/main.c   |   67 +++++++++++++------------------
 drivers/net/wireless/ti/wl1251/wl1251.h |    1 -
 3 files changed, 28 insertions(+), 49 deletions(-)

