Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56799 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758898Ab1DNOlW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 10:41:22 -0400
Received: by bwz15 with SMTP id 15so1431757bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 07:41:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=mK2r_ZSStDhMSeHcFrx-jx=pN3A@mail.gmail.com>
References: <BANLkTimreffpSdBUogakk=E6Hn1Lf6KJ_w@mail.gmail.com>
 <BANLkTi=BgKRJXqM+8idBr-txCDPGFQSFhw@mail.gmail.com> <BANLkTi=Dtbhz=kGUSdH57JRG1DoRFP7kLw@mail.gmail.com>
 <201104131843.57676.chunkeey@googlemail.com> <BANLkTi=xyrWoYMeYCJjGhHgi=2W-CCBF7w@mail.gmail.com>
 <BANLkTi=mK2r_ZSStDhMSeHcFrx-jx=pN3A@mail.gmail.com>
From: Damian Lesiuk <lesiuk@gmail.com>
Date: Thu, 14 Apr 2011 16:40:41 +0200
Message-ID: <BANLkTi=gTS5DvT+JMr35Q4puaqUaUy5Bww@mail.gmail.com>
Subject: Re: carl9170: TP-LINK TL-WN822N slow connection speeds (16 mbps)
 MASTER MODE
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

uniwersytecka-server ~ # iw wlan0 station dump
Station 74:f0:6d:33:ea:00 (on wlan0)
       inactive time:  20 ms
       rx bytes:       5043668
       rx packets:     9305
       tx bytes:       13762256
       tx packets:     11634
       signal:         -31 dBm
       tx bitrate:     65.0 MBit/s MCS 7

So it helped in some way.
Why that network isn't 300 mbps?

My config is:
interface=wlan0
driver=nl80211
ssid=lesiuk
channel=7
hw_mode=g
ieee80211n=1
wme_enabled=1
ht_capab=[HT40-][SHORT-GI-40][DSSS_CCK-40]
