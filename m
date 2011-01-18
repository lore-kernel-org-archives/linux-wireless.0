Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46539 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab1ARTlU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 14:41:20 -0500
Received: by eye27 with SMTP id 27so3503307eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jan 2011 11:41:19 -0800 (PST)
Message-ID: <4D35ECD8.8070000@gmail.com>
Date: Tue, 18 Jan 2011 11:41:12 -0800
From: JD <jd1008@gmail.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: Does linux wireless support TL-WN861N
References: <4D35E5FD.8030804@gmail.com> <AANLkTinS784Pw27axvMty578tK=gmvVoFGp6iUQNL7V3@mail.gmail.com>
In-Reply-To: <AANLkTinS784Pw27axvMty578tK=gmvVoFGp6iUQNL7V3@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/18/2011 11:23 AM, Rafał Miłecki wrote:
> 2011/1/18 JD<jd1008@gmail.com>:
>> TP-Link TL-WN861N
>> see
>> http://www.tp-link.com/products/productDetails.asp?class=&content=spe&pmodel=TL-WN861N
> https://forum.openwrt.org/viewtopic.php?id=25431
> http://www.wikidevi.com/wiki/TP-LINK_TL-WN861N_v2
>
> Both sources tell about AR9223 chipset, but I is not mentioned on
> http://wireless.kernel.org/en/users/Drivers/ath9k
>
> Maybe someone from ath9k ML knows it? Or try to Google it.
>
Thanx Rafal.
I did find it listed on

http://wireless.kernel.org/en/users/Drivers/ath9k/products/external?highlight=%28TL-WN861N%29

However, I also found out that it has very very poor Rx sensitivity 
(only -68 dBm) at 11g,
and much much less at 11N. My location relative to AP is very bad. I 
need a card supported
by ath9k and with Rx sensitivity that can go all the way to -97dBm.

Cheers,

JD
