Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60453 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1GUOn3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 10:43:29 -0400
Received: by vxh35 with SMTP id 35so927181vxh.19
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2011 07:43:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAN=pzdLHHgyPxEbCOGEXvbuhAYZ863fW_Rai5OWWxE8yHai1jw@mail.gmail.com>
References: <CAN=pzdLRaRHkg4NquUpDhEwRzq-roKQXMtMcwnr031maDSLRfw@mail.gmail.com>
	<CAGXE3d9HgRvdJModc3hSA25+jLktZJ3i997oq7GfZz4dUJfuvw@mail.gmail.com>
	<CAN=pzdKHWNcvwAn3uDMzTdpvv3MkM9KNC89NuzZX=z6npBnUGg@mail.gmail.com>
	<201107211613.01938.helmut.schaa@googlemail.com>
	<CAN=pzdLHHgyPxEbCOGEXvbuhAYZ863fW_Rai5OWWxE8yHai1jw@mail.gmail.com>
Date: Thu, 21 Jul 2011 18:43:28 +0400
Message-ID: <CAN=pzd+EFcyRnexjiMMLNR86hT_UKiePr=yCkZZk5dD4sqYSew@mail.gmail.com> (sfid-20110721_164332_093993_EDBE4772)
Subject: Re: rt2x00, AP mode, 802.11n is not working properly
From: Stanislav Demakov <s.demakov@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just applied your patch to 2011-07-20 manually and now download speed
is around 1 MByte/s which is better than it was before (100-200kb/s).

Maybe you could give an advice what else should I try to change?
Because in 2010-12-13 version DL speed is still better and around
4MByte\s.

2011/7/21 Stanislav Demakov <s.demakov@gmail.com>:
>>>Disabling WMM might force some clients to disable 11n, not sure though how
> this relates.
>
> That's right, this is why I need it to work properly when it's enabled.
> E.g my netbook can handle 11n without WMM and I get 65mbps, but
> iDevices (ipad ipod) will only connect in G mode in this case.
>
>
> 2011/7/21 Helmut Schaa <helmut.schaa@googlemail.com>:
>> Am Donnerstag, 21. Juli 2011 schrieb Stanislav Demakov:
>>> This patch won't apply on current compat-wireless-2011-07-20.tar.bz2
>>>
>>> (Stripping trailing CRs from patch.)
>>> patching file b/drivers/net/wireless/rt2x00/rt2800lib.c
>>> Hunk #1 FAILED at 4194.
>>> 1 out of 1 hunk FAILED -- saving rejects to file
>>> b/drivers/net/wireless/rt2x00/rt2800lib.c.rej
>>> (Stripping trailing CRs from patch.)
>>> patching file b/drivers/net/wireless/rt2x00/rt2800usb.c
>>> Hunk #1 FAILED at 527.
>>> patch unexpectedly ends in middle of line
>>> Hunk #2 FAILED at 820.
>>> 2 out of 2 hunks FAILED -- saving rejects to file
>>> b/drivers/net/wireless/rt2x00/rt2800usb.c.rej
>>>
>>> Should I use another version of compat wireless or edit files manually?
>>
>> Just edit manually, it's not much ...
>>
>>> Also I have no stability issues, the connection is stable, but as I
>>> said the TX speed from AP running rt2x00 (the driver is in Master
>>> mode) to client is extremely slow in 802.11n+WMM mode.
>>
>> Yeah, understood. That's what I saw in STA mode as well. Now I get a stable
>> transmit speed >20Mbps (MCS7 20Mhz).
>>
>>> And this is only WMM mode related, because wIthout it everything is fine.
>>
>> Disabling WMM might force some clients to disable 11n, not sure though how
>> this relates.
>>
>> Helmut
>>
>
