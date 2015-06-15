Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:30479 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbbFOSTH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 14:19:07 -0400
Message-ID: <557F1716.3040204@broadcom.com> (sfid-20150615_201910_981481_79C5AD0A)
Date: Mon, 15 Jun 2015 20:19:02 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@venema.h4ckr.net>,
	"Felix Fietkau" <nbd@openwrt.org>, Jouni Malinen <j@w1.fi>
Subject: Re: [RFC] ath9k: advertise p2p dev support when chanctx
References: <1433913034-17801-1-git-send-email-janusz.dziedzic@tieto.com>	<21886.43539.833126.629494@gargle.gargle.HOWL>	<CALhHN=pUKuXAEb3JEEVTHATEHhvoLe52QDh-pixiS9oUo=6j6Q@mail.gmail.com> <21886.62363.946771.345441@gargle.gargle.HOWL>
In-Reply-To: <21886.62363.946771.345441@gargle.gargle.HOWL>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ Jouni

On 06/15/15 17:47, Sujith Manoharan wrote:
> Janusz Dziedzic wrote:
>>> At least the callbacks for adding/removing interfaces need
>>> to be handled ?
>>>
>> Strange, but I didn't hit any problem yet with my simple patch.
>
> Ok. But I am not very familiar with how p2p-device is supposed
> to be used...

The p2p-device is designed to be used for p2p discovery and p2p action 
frame exchange. It make it easier for driver and/or firmware to 
determine if user-space request is p2p related or not. However, in 
discussions with Jouni I got the impression that ath (or qca) firmware 
and/or drivers did not need this design. Not sure if that claim is 
unaffected by the "use_chanctx=1" parameter.

Regards,
Arend

> Sujith
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

