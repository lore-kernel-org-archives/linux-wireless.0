Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:58795 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab3GYLSd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Jul 2013 07:18:33 -0400
Received: by mail-oa0-f41.google.com with SMTP id n10so3993129oag.14
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jul 2013 04:18:32 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 25 Jul 2013 13:18:32 +0200
Message-ID: <CABikg9w6fGa=6ZxEa+X3npkrupQPCrqnHxDbwNzD6GrepWdSZg@mail.gmail.com> (sfid-20130725_131836_087703_BC042ED8)
Subject: AR5008 "Failed to stop TX DMA"
From: Sergei Antonov <saproj@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!
I use "Atheros Communications Inc. AR5008 Wireless Network Adapter
(rev 01)" PCI card.
The following messages appear in my console approx. once in a minute.

cfg80211: Calling CRDA to update world regulatory domain
ath: phy0: Failed to stop TX DMA, queues=0x001!
wlan0: authenticate with 00:15:af:xx:xx:xx
wlan0: send auth to 00:15:af:xx:xx:xx (try 1/3)
wlan0: authenticated
ath9k 0000:03:06.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
ath9k 0000:03:06.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
wlan0: associate with 00:15:af:xx:xx:xx (try 1/3)
wlan0: RX AssocResp from 00:15:af:xx:xx:xx (capab=0x411 status=0 aid=3)
wlan0: associated

The connection to WPA access point works, although SSH freezes
regulary for several seconds.

I'm running an x86_64 kernel version 3.10.2. But earlier versions had
the same problem too.
Please, help me to fix that.
