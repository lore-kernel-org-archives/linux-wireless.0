Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:36378 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbaBEVho (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Feb 2014 16:37:44 -0500
Received: by mail-ea0-f175.google.com with SMTP id z10so509809ead.6
        for <linux-wireless@vger.kernel.org>; Wed, 05 Feb 2014 13:37:42 -0800 (PST)
From: andrea merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	andrea merello <andrea.merello@gmail.com>
Subject: [PATCH 0/4] rtl818x: port fixes from rtl8187se merge process
Date: Wed,  5 Feb 2014 22:38:03 +0100
Message-Id: <1391636287-17712-1-git-send-email-andrea.merello@gmail.com> (sfid-20140205_223747_693102_DB766AE4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While working on rtl818x driver for adding rtl8187se support I have
made some fixes and improvements unrelated to rtl8187se support itself.

In this first patch set I include the following four changes:

andrea.merello (4):
  In rtl8180/rtl8187 drivers, few register bit definitions have
    misleading names. Fix them
  Add error check for pci_map_single return value in rtl8180 RX path
  Add error check for pci_map_single return value in rtl8180 TX path
  Write rtl8180 beacon interval register when beacon interval changes

 drivers/net/wireless/rtl818x/rtl8180/dev.c | 37 +++++++++++++++++++++++-------
 drivers/net/wireless/rtl818x/rtl8187/dev.c | 16 ++++++-------
 drivers/net/wireless/rtl818x/rtl818x.h     | 12 +++++-----
 3 files changed, 43 insertions(+), 22 deletions(-)

-- 
1.8.3.2

