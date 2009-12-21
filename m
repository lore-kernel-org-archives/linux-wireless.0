Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:38484 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365AbZLUMgq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 07:36:46 -0500
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id nBLCaW61012879
	for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2009 14:36:44 +0200
Received: from [127.0.1.1] (trdhcp21540.nmp.nokia.com [172.22.215.40])
	by mgw-da02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id nBLCaPfS023380
	for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2009 14:36:25 +0200
Subject: [RFC PATCH] wl1271 testmode support
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 21 Dec 2009 14:36:25 +0200
Message-ID: <20091221120745.18850.67739.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I implemented testmode support for wl1271. I would appreciate any comments
about this before we start to use this.

---

Kalle Valo (1):
      wl1271: add testmode support


 drivers/net/wireless/wl12xx/Makefile          |    1 
 drivers/net/wireless/wl12xx/wl1271.h          |    2 
 drivers/net/wireless/wl12xx/wl1271_main.c     |    2 
 drivers/net/wireless/wl12xx/wl1271_testmode.c |  305 +++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_testmode.h |   31 +++
 5 files changed, 340 insertions(+), 1 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_testmode.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_testmode.h

