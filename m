Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42740 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758875Ab1DNPH4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 11:07:56 -0400
Received: by bwz15 with SMTP id 15so1452808bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 08:07:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTingZRChrOtSPbat6D69_nW=6DpADw@mail.gmail.com>
References: <BANLkTimreffpSdBUogakk=E6Hn1Lf6KJ_w@mail.gmail.com>
 <BANLkTi=BgKRJXqM+8idBr-txCDPGFQSFhw@mail.gmail.com> <BANLkTi=Dtbhz=kGUSdH57JRG1DoRFP7kLw@mail.gmail.com>
 <201104131843.57676.chunkeey@googlemail.com> <BANLkTi=xyrWoYMeYCJjGhHgi=2W-CCBF7w@mail.gmail.com>
 <BANLkTi=mK2r_ZSStDhMSeHcFrx-jx=pN3A@mail.gmail.com> <BANLkTi=gTS5DvT+JMr35Q4puaqUaUy5Bww@mail.gmail.com>
 <BANLkTingZRChrOtSPbat6D69_nW=6DpADw@mail.gmail.com>
From: Damian Lesiuk <lesiuk@gmail.com>
Date: Thu, 14 Apr 2011 17:07:15 +0200
Message-ID: <BANLkTin9Xp0oNkLANM0pkr7dyOCpEwow+g@mail.gmail.com>
Subject: Re: carl9170: TP-LINK TL-WN822N slow connection speeds (16 mbps)
 MASTER MODE
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have draft N router next to that device.
He is working at 1 channel. I can easily reach 100 mbps with him.

I changed channel to 11 and I have MSC 5.

I have Azurewave NB290 in my notebook.
But I tested it also with Atheros 9280 and connection here was very
bad (8 mbps).

2011/4/14 Helmut Schaa <helmut.schaa@googlemail.com>:
> On Thu, Apr 14, 2011 at 4:40 PM, Damian Lesiuk <lesiuk@gmail.com> wrote:
>> uniwersytecka-server ~ # iw wlan0 station dump
>> Station 74:f0:6d:33:ea:00 (on wlan0)
>>       inactive time:  20 ms
>>       rx bytes:       5043668
>>       rx packets:     9305
>>       tx bytes:       13762256
>>       tx packets:     11634
>>       signal:         -31 dBm
>>       tx bitrate:     65.0 MBit/s MCS 7
>>
>> So it helped in some way.
>> Why that network isn't 300 mbps?
>
> 300mbps is only possible in HT40 mode. However, hostapd will disable
> HT40 if it detects
> an other HT40 AP on an overlapping channel (in your case anything
> !=7). This is also
> in accordance with 802.11n-2009.
>
> Hostapd will print "40 MHz pri/sec mismatch with BSS ..." in that case.
>
> Furthermore, it seems that the station 74:f0:6d:33:ea:00 isn't capable
> of using multiple
> spacial streams and thus is limited to MCS7. What client device is this?
>
> Helmut
>
