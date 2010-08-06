Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50196 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761721Ab0HFSts (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 14:49:48 -0400
Received: by eya25 with SMTP id 25so2902634eya.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Aug 2010 11:49:47 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 0/7] rt2x00 update
Date: Fri, 6 Aug 2010 20:45:04 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201008062045.05288.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is a fresh update for rt2x00 for 2.6.37, most notable
change is the move of TX/RX handling to a workqueue, but
more importantly the more accurate TX status reporting
for rt2800usb

Helmut Schaa (2):
      rt2x00: Set MIMO PS flag in tx descriptor for STAs in dynamic SMPS mode
      rt2x00: Update comments regarding TXWI and TX_STA_FIFO

Ivo van Doorn (5):
      rt2x00: Move USB tx/rx done handling to workqueue
      rt2x00: Add helper function for reporting tx status
      rt2x00: Request TXWI pointer from driver
      rt2x00: Implement TX status reporting for rt2800usb
      rt2x00: Remove ieee80211_rx_status from rt2x00_dev

Ivo
