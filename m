Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:19143 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab0EEK01 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 May 2010 06:26:27 -0400
Received: by ey-out-2122.google.com with SMTP id 9so208384eyd.5
        for <linux-wireless@vger.kernel.org>; Wed, 05 May 2010 03:26:26 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 5 May 2010 12:26:25 +0200
Message-ID: <r2xf69abfc31005050326oe123cb60s131ab4969341ef57@mail.gmail.com>
Subject: 2.6.33.2: Turn tx power off/on for Atheros card
From: Yegor Yefremov <yegorslists@googlemail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm using kernel 2.6.33.2 with AR2413 WLAN card. Issuing

iwconfig wlan0 txpower off

turns txpower off. I can see this status by iwconfig wlan0 and the
communication with AP terminates. But when I turn the txpower on

iwconfig wlan0 txpower on

nothing happens. Though iwconfig shows the previous tx power value.
Only ifconfig wlan0 down and then up recovers the transmission.

Is it a known bug or I'm doing something wrong?

Regards,
Yegor
