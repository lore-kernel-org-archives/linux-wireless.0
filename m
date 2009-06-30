Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-1920.google.com ([74.125.78.145]:28407 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbZF3VQp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 17:16:45 -0400
Received: by ey-out-1920.google.com with SMTP id 3so112882eyh.36
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2009 14:16:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090630170916.GB5137@sprite>
References: <20090630170916.GB5137@sprite>
Date: Wed, 1 Jul 2009 00:16:47 +0300
Message-ID: <40f31dec0906301416m39e6943ewef8d9c5bc5591880@mail.gmail.com>
Subject: Re: ath5k and Atheros AR242x - No scan results
From: Nick Kossifidis <mickflemm@gmail.com>
To: Joel Roth <joelz@pobox.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/6/30 Joel Roth <joelz@pobox.com>:
> Hello all,
>
> I'd appreciate some help troubleshooting my wireless connection.
>
> I have a Toshiba Satellite L305 series laptop running Debian
> sid with a recent, stock Debian kernel version 2.6.29-2-486.
>
> $ lspci | grep Atheros
>
> 05:00.0 Ethernet controller: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter (rev 01)
>
> I am seeking to connect to a D-Link 614+ wireless router.
> For initial testing, the AP is unencrypted, unsecured.
>
> My wife's G3 i-Book with AfterTheMac USB wireless adapter
> connected just fine, on the first try.
>
> I believe I have the modules I should have:
>
> $ lsmod | grep 80211
> mac80211              139680  1 ath5k
> cfg80211               21576  2 ath5k,mac80211
>
> My wireless network interface is present:
>
> $ iwconfig wlan0
>
> wlan0     IEEE 802.11  ESSID:""
>          Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated
>          Tx-Power=0 dBm
>          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
>          Link Quality:0  Signal level:0  Noise level:0
>          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>
> $ ifconfig wlan0
>
> wlan0     Link encap:Ethernet  HWaddr 00:21:63:82:82:40
>          UP BROADCAST MULTICAST  MTU:1500  Metric:1
>          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>          collisions:0 txqueuelen:1000
>          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
>
>
> However, I don't find the D-Link 614+:
>
> $ iwlist wlan0 scan
>
> wlan0     No scan results
>
> And of course, dhclient fails to find a server.
>
> Am I missing something? What could I try next?
> I'd appreciate any pointers.
>
> Thanks.
>
> --
> Joel Roth

Hello ;-)

Can you please sent the dmesg output when ath5k loads ?
Also do you see any messages on dmesg while scaning ?




-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
