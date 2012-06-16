Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49280 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab2FPT0z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2012 15:26:55 -0400
Received: by wgbdr13 with SMTP id dr13so4227687wgb.1
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jun 2012 12:26:54 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 0/3] wl1251: maemo fixes
Date: Sat, 16 Jun 2012 22:26:45 +0300
Message-Id: <1339874808-9991-1-git-send-email-notasas@gmail.com> (sfid-20120616_212735_392477_3B941E59)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are a few old wl1251 patches found in maemo repositories that haven't
ever reached mainline. I did not keep 'From:' and s-o-b as the patches are
rebased and slightly modified, also most emails are probably dead due to
Nokia's reorganization, so original authors are just listed in commit
messages.

Grazvydas Ignotas (3):
  wl1251: remove unused filter_work
  wl1251: fix filtering support
  wl1251: send filters to firmware as they are set

 drivers/net/wireless/ti/wl1251/cmd.c    |    9 ----
 drivers/net/wireless/ti/wl1251/main.c   |   67 +++++++++++++------------------
 drivers/net/wireless/ti/wl1251/wl1251.h |    1 -
 3 files changed, 28 insertions(+), 49 deletions(-)

