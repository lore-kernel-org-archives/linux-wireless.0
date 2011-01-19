Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45851 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab1ASUGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 15:06:44 -0500
Received: by vws16 with SMTP id 16so582056vws.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 12:06:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D35ECD8.8070000@gmail.com>
References: <4D35E5FD.8030804@gmail.com>
	<AANLkTinS784Pw27axvMty578tK=gmvVoFGp6iUQNL7V3@mail.gmail.com>
	<4D35ECD8.8070000@gmail.com>
Date: Wed, 19 Jan 2011 15:06:43 -0500
Message-ID: <AANLkTi=F3vcp0xMOzw7VeAbw-ciy+tq_ycipOwrXzs+Q@mail.gmail.com>
Subject: Re: Does linux wireless support TL-WN861N
From: Brian Prodoehl <bprodoehl@gmail.com>
To: JD <jd1008@gmail.com>
Cc: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/1/18 JD <jd1008@gmail.com>:
> On 01/18/2011 11:23 AM, Rafał Miłecki wrote:
>>
>> 2011/1/18 JD<jd1008@gmail.com>:
>>>
>>> TP-Link TL-WN861N
>>> see
>>>
>>> http://www.tp-link.com/products/productDetails.asp?class=&content=spe&pmodel=TL-WN861N
>>
>> https://forum.openwrt.org/viewtopic.php?id=25431
>> http://www.wikidevi.com/wiki/TP-LINK_TL-WN861N_v2
>>
>> Both sources tell about AR9223 chipset, but I is not mentioned on
>> http://wireless.kernel.org/en/users/Drivers/ath9k
>>
>> Maybe someone from ath9k ML knows it? Or try to Google it.
>>
> Thanx Rafal.
> I did find it listed on
>
> http://wireless.kernel.org/en/users/Drivers/ath9k/products/external?highlight=%28TL-WN861N%29
>
> However, I also found out that it has very very poor Rx sensitivity (only
> -68 dBm) at 11g,
> and much much less at 11N. My location relative to AP is very bad. I need a
> card supported
> by ath9k and with Rx sensitivity that can go all the way to -97dBm.
>
> Cheers,
>
> JD

That sensitivity number is the sensitivity at the 54Mbps bitrate.  If
you're comparing product briefs or datasheets, make sure you're
comparing numbers for the same bitrate.  That card can receive 1Mbps
down to -90dBm, and 6Mbps down to -88dBm.  You'll find cards with
sensitivity 6 or 7dB better, but that's about it.

-Brian
