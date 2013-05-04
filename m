Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:57293 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757133Ab3EDP7I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 May 2013 11:59:08 -0400
Received: by mail-ob0-f173.google.com with SMTP id 6so2129085oba.4
        for <linux-wireless@vger.kernel.org>; Sat, 04 May 2013 08:59:08 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 4 May 2013 17:59:08 +0200
Message-ID: <CABikg9xcnPh0UQC-zSRwUASkBJ+GxjAMCvv2U4TpDniK3kTdkg@mail.gmail.com> (sfid-20130504_175913_537293_ED2CC586)
Subject: ath: phy0: Failed to stop TX DMA
From: Sergei Antonov <saproj@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!
The following messages appear in my console approx. once in a minute.
Please, help me to fix that.

kernel: cfg80211: Calling CRDA to update world regulatory domain
kernel: ath: phy0: Failed to stop TX DMA, queues=0x001!
kernel: wlp3s6: authenticate with 00:15:af:xx:xx:xx
kernel: wlp3s6: send auth to 00:15:af:xx:xx:xx (try 1/3)
kernel: wlp3s6: authenticated
kernel: ath9k 0000:03:06.0 wlp3s6: disabling HT as WMM/QoS is not
supported by the AP
kernel: ath9k 0000:03:06.0 wlp3s6: disabling VHT as WMM/QoS is not
supported by the AP
kernel: wlp3s6: associate with 00:15:af:xx:xx:xx (try 1/3)
kernel: wlp3s6: RX AssocResp from 00:15:af:xx:xx:xx (capab=0x411 status=0 aid=3)
kernel: wlp3s6: associated

I use "Atheros Communications Inc. AR5008 Wireless Network Adapter
(rev 01)" PCI card on linux-3.8.8 x86_64.
The connection to WPA access point works, although SSH freezes
periodically for a couple of seconds.

The first message comes from net/wireless/reg.c
, the second from drivers/net/wireless/ath/ath9k/xmit.c and is output
via ath_err().
Looks like something is wrong with my system. I need assistance to resolve it.
