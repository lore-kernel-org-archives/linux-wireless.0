Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53680 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab1DNNZ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 09:25:27 -0400
Received: by bwz15 with SMTP id 15so1366974bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 06:25:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTim5-T-kLPBw3iACRedU1WkXAeC-7g@mail.gmail.com>
References: <BANLkTimreffpSdBUogakk=E6Hn1Lf6KJ_w@mail.gmail.com>
 <BANLkTi=BgKRJXqM+8idBr-txCDPGFQSFhw@mail.gmail.com> <BANLkTi=Dtbhz=kGUSdH57JRG1DoRFP7kLw@mail.gmail.com>
 <201104131843.57676.chunkeey@googlemail.com> <BANLkTi=xyrWoYMeYCJjGhHgi=2W-CCBF7w@mail.gmail.com>
 <BANLkTiniLthxh6iUyzLZ+WHCbUvJ6gP+Gw@mail.gmail.com> <BANLkTim5-T-kLPBw3iACRedU1WkXAeC-7g@mail.gmail.com>
From: Damian Lesiuk <lesiuk@gmail.com>
Date: Thu, 14 Apr 2011 15:24:37 +0200
Message-ID: <BANLkTinhC7OEL02Bpph+kKECJvJMKxu9NQ@mail.gmail.com>
Subject: Re: carl9170: TP-LINK TL-WN822N slow connection speeds (16 mbps)
 MASTER MODE
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I made new tcpdump log with hostapd 0.7.3
http://uniwersytecka.dyndns.biz/~lesiuk/dump2

2011/4/14 Damian Lesiuk <lesiuk@gmail.com>:
> I can give you any debug informations you need.
> I really want make it work.
>
> 2011/4/14 Damian Lesiuk <lesiuk@gmail.com>:
>> btw, I shortened my hostapd config to
>>
>> interface=wlan0
>> driver=nl80211
>> ssid=lesiuk
>> channel=7
>> hw_mode=g
>> ieee80211n=1
>> wme_enabled=1
>> ht_capab=[HT40-][SHORT-GI-40]
>>
>> And I see that as 75 mbps network.
>>
>
