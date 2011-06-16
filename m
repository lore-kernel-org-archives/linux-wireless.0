Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47855 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384Ab1FPUNV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2011 16:13:21 -0400
Received: by bwz15 with SMTP id 15so262313bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jun 2011 13:13:20 -0700 (PDT)
Subject: Status of carl9170
From: Thomas Novin <thomas@xyz.pp.se>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 16 Jun 2011 22:13:16 +0200
Message-ID: <1308255196.4264.7.camel@thnov-desktop.xyz.lan> (sfid-20110616_221337_352799_AC1D4E69)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

I accidentally bought two TP-Link TL-WN821N v2 (accidentally because I
was going for v3). I've tried using them with compat-wireless (just now
tested with 2011-06-15) & the carl9170-driver.

When using these to connect to my Ubiquiti Power AP-N I get terrible
performance. Using another computer with some Broadcom 802.11g chip (b43
driver) it works OK.

For example, doing a 100 packet ping towards my LAN gateway and at the
same time trying to load a webpage.

--- 10.0.0.254 ping statistics ---
100 packets transmitted, 60 received, 40% packet loss, time 99229ms
rtt min/avg/max/mdev = 0.832/93.193/1264.009/292.193 ms, pipe 2

wlan0     IEEE 802.11bgn  ESSID:"POWERAPN"  
          Mode:Managed  Frequency:2.427 GHz  Access Point:
00:15:6D:9E:D2:A0
          Bit Rate=58.5 Mb/s   Tx-Power=20 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=64/70  Signal level=-46 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:4  Invalid misc:0   Missed beacon:0

Being closer to the AP with better link quality  doesn't help at all.

Should I just get some other USB adapter or is there hope for the ones
that I have? If other, which ones are best supported? I really don't
care about GPL firmware, I just want stable & fast 802.11n performance.

Rgds//Thomas

