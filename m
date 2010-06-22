Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40232 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755913Ab0FVOul (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jun 2010 10:50:41 -0400
From: Sebastian Smolorz <Sebastian.Smolorz@gmx.de>
To: kalle.valo@iki.fi
Subject: [PATCH 0/2] at76c50x-usb.c: Fix broken authentication process
Date: Tue, 22 Jun 2010 16:51:24 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201006221651.24853.Sebastian.Smolorz@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix authentication process of wireless driver at76c50x-usb.c which was broken
since kernel 2.6.31

Sebastian Smolorz (2):
  at76c50x-usb: Move function at76_join() several lines up
  at76c50x-usb: Extract bssid from authentication frame

 drivers/net/wireless/at76c50x-usb.c |  108 +++++++++++++++++++++++------------
 drivers/net/wireless/at76c50x-usb.h |    1 +
 2 files changed, 73 insertions(+), 36 deletions(-)

