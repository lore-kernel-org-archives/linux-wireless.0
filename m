Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58540 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758844Ab1DNOvM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 10:51:12 -0400
Received: by bwz15 with SMTP id 15so1439743bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 07:51:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=gTS5DvT+JMr35Q4puaqUaUy5Bww@mail.gmail.com>
References: <BANLkTimreffpSdBUogakk=E6Hn1Lf6KJ_w@mail.gmail.com>
 <BANLkTi=BgKRJXqM+8idBr-txCDPGFQSFhw@mail.gmail.com> <BANLkTi=Dtbhz=kGUSdH57JRG1DoRFP7kLw@mail.gmail.com>
 <201104131843.57676.chunkeey@googlemail.com> <BANLkTi=xyrWoYMeYCJjGhHgi=2W-CCBF7w@mail.gmail.com>
 <BANLkTi=mK2r_ZSStDhMSeHcFrx-jx=pN3A@mail.gmail.com> <BANLkTi=gTS5DvT+JMr35Q4puaqUaUy5Bww@mail.gmail.com>
From: Damian Lesiuk <lesiuk@gmail.com>
Date: Thu, 14 Apr 2011 16:50:31 +0200
Message-ID: <BANLkTik2F_6w5jacYw+2-=7Jken6aF_RBQ@mail.gmail.com>
Subject: Re: carl9170: TP-LINK TL-WN822N slow connection speeds (16 mbps)
 MASTER MODE
To: linux-wireless@vger.kernel.org
Cc: chunkeey@googlemail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

btw I have 40 mbps now WOW!! :)
But my windows 7 laptop still shows it as 75 mbps connection.

2011/4/14 Damian Lesiuk <lesiuk@gmail.com>:
> uniwersytecka-server ~ # iw wlan0 station dump
> Station 74:f0:6d:33:ea:00 (on wlan0)
>       inactive time:  20 ms
>       rx bytes:       5043668
>       rx packets:     9305
>       tx bytes:       13762256
>       tx packets:     11634
>       signal:         -31 dBm
>       tx bitrate:     65.0 MBit/s MCS 7
>
> So it helped in some way.
> Why that network isn't 300 mbps?
>
> My config is:
> interface=wlan0
> driver=nl80211
> ssid=lesiuk
> channel=7
> hw_mode=g
> ieee80211n=1
> wme_enabled=1
> ht_capab=[HT40-][SHORT-GI-40][DSSS_CCK-40]
>
