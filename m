Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48343 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab1DOJ1Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 05:27:25 -0400
Received: by bwz15 with SMTP id 15so2040685bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Apr 2011 02:27:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTik5jzVUHaPKm6Tu-shDOwLkcyUt0A@mail.gmail.com>
References: <BANLkTimreffpSdBUogakk=E6Hn1Lf6KJ_w@mail.gmail.com>
 <BANLkTi=HaJ0ZrtmDo=wwBOrEweZrjHqWXw@mail.gmail.com> <BANLkTikyCcN6dP0DiQboXv4rDoSGqTDdTA@mail.gmail.com>
 <201104142251.10881.chunkeey@googlemail.com> <BANLkTinpodW6rjQ7GTOFkVV7L=KG8kuS7Q@mail.gmail.com>
 <BANLkTimw4SOgMHXNJmue-JsbXD4QuMjmgQ@mail.gmail.com> <BANLkTimmdRi_CmwgH14aJbQJecYav-4r8Q@mail.gmail.com>
 <BANLkTimfifFrKdgYuMvAMhSGKAJXu3W9mA@mail.gmail.com> <BANLkTik5jzVUHaPKm6Tu-shDOwLkcyUt0A@mail.gmail.com>
From: Damian Lesiuk <lesiuk@gmail.com>
Date: Fri, 15 Apr 2011 11:26:44 +0200
Message-ID: <BANLkTikUS=G3J7C3HSNnHJGGTeZ9OR+qPw@mail.gmail.com>
Subject: Re: carl9170: TP-LINK TL-WN822N slow connection speeds (16 mbps)
 MASTER MODE
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After aplying this patch:

Station 74:f0:6d:33:ea:00 (on wlan0)
        inactive time:  50 ms
        rx bytes:       4501008
        rx packets:     45502
        tx bytes:       123883066
        tx packets:     83649
        signal:         -32 dBm
        tx bitrate:     150.0 MBit/s MCS 7 40Mhz short GI

I can get now 55 mbps.
It's max for me?

2011/4/15 Damian Lesiuk <lesiuk@gmail.com>:
> Ok I found it.
> https://dev.openwrt.org/browser/trunk/package/hostapd/patches/130-scan_wait.patch?rev=20090
>
> 2011/4/15 Damian Lesiuk <lesiuk@gmail.com>:
>> Look at noscan option in their docs.
>> http://wiki.openwrt.org/doc/uci/wireless
>>
>> 2011/4/15 Damian Lesiuk <lesiuk@gmail.com>:
>>> Openwrt have noscan option with mac80211
>>> (https://dev.openwrt.org/browser/branches/backfire/package/mac80211/files/lib/wifi/mac80211.sh?rev=22356)
>>> They patched code?
>>>
>>> Where can I find that patch?
>>>
>>> 2011/4/15 Helmut Schaa <helmut.schaa@googlemail.com>:
>>>> On Fri, Apr 15, 2011 at 8:22 AM, Damian Lesiuk <lesiuk@gmail.com> wrote:
>>>>> Is there option to do not scan for overlapping BSSs?
>>>>
>>>> AFAIK not without patching the code.
>>>>
>>>> Helmut
>>>>
>>>
>>
>
