Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49613 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759947Ab3CICLE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 21:11:04 -0500
Received: by mail-wi0-f178.google.com with SMTP id hq4so76423wib.11
        for <linux-wireless@vger.kernel.org>; Fri, 08 Mar 2013 18:11:02 -0800 (PST)
Message-ID: <513A9A34.8090701@gmail.com> (sfid-20130309_031109_554020_155EE050)
Date: Sat, 09 Mar 2013 03:11:00 +0100
From: Jenya Y <jy.gerstmaier@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: PROBLEM: linux kernel 3.9 rc1 and rtl8187 wireless, unable to
 connect to any available hotspots.
References: <51380336.6030007@live.com> <BLU0-SMTP15357D4D2469B872AE4355CF1E50@phx.gbl> <5138109D.1040605@lwfinger.net> <BLU0-SMTP18556F96AB7DC8FE9D76DA3F1E50@phx.gbl> <513936C8.5060908@lwfinger.net> <513A04BD.3020002@gmail.com> <513A0D9D.8020600@lwfinger.net> <513A1F5F.3080209@gmail.com> <513A2824.30603@lwfinger.net> <513A4154.3040000@gmail.com> <513A51E6.9090704@lwfinger.net> <513A56B8.7050900@gmail.com> <513A91F5.9030007@lwfinger.net>
In-Reply-To: <513A91F5.9030007@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I see that had no effect. You need to bisect between HEAD and v3.8.
>
> Larry

Larry, I'm very happy to report that after recompiling the kernel from 
git master just a few minutes ago all is working again! Thank you very 
much for your patience with my ignorance. (and all kudos to you, friend, 
comrade, sister or brother....whoever you are on other end of the wire 
who managed to fix this :)

So I'm off bothering Mighty Alan again until the other problem with my 
usb hub in the display is solved :) Have to brace myself for another 
round of awkward comments, I guess.

Thank you again! I will familiar with bisecting soon enough.

// Jenya



[    0.000000] Linux version 3.9.0-1-jy-alpha (jy@Y8) (gcc version 4.7.2 
(GCC) ) #1 SMP PREEMPT Sat Mar 9 02:33:53 CET 2013
.....
[   18.412863] ieee80211 phy0: hwaddr 00:15:af:03:b1:88, RTL8187vB 
(default) V1 + rtl8225z2, rfkill mask 2
[   18.423761] rtl8187: Customer ID is 0x00
[   18.424413] rtl8187: wireless switch is on
[   18.424799] usbcore: registered new interface driver rtl8187
[   18.466185] systemd-udevd[294]: renamed network interface wlan0 to 
wlp0s29f7u7u3
[   20.361794] IPv6: ADDRCONF(NETDEV_UP): wlp0s29f7u7u3: link is not ready
[   23.724490] wlp0s29f7u7u3: authenticate with 00:13:49:df:22:72
[   23.868638] wlp0s29f7u7u3: send auth to 00:13:49:df:22:72 (try 1/3)
[   23.871268] wlp0s29f7u7u3: authenticated
[   23.871402] rtl8187 5-7.3:1.0 wlp0s29f7u7u3: disabling HT as WMM/QoS 
is not supported by the AP
[   23.871407] rtl8187 5-7.3:1.0 wlp0s29f7u7u3: disabling VHT as WMM/QoS 
is not supported by the AP
[   23.872038] wlp0s29f7u7u3: associate with 00:13:49:df:22:72 (try 1/3)
[   23.874879] wlp0s29f7u7u3: RX AssocResp from 00:13:49:df:22:72 
(capab=0x411 status=0 aid=1)
[   23.875634] wlp0s29f7u7u3: associated
[   23.875662] IPv6: ADDRCONF(NETDEV_CHANGE): wlp0s29f7u7u3: link 
becomes ready

