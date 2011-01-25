Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35186 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab1AYMfl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 07:35:41 -0500
Received: by bwz15 with SMTP id 15so79040bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 04:35:40 -0800 (PST)
Message-ID: <4D3EC398.5040102@googlemail.com>
Date: Tue, 25 Jan 2011 13:35:36 +0100
From: Dennis Borgmann <dennis.borgmann@googlemail.com>
MIME-Version: 1.0
To: Josef Windorfer <josefwindorfer@gmx.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: mini PCI express WLAN card
References: <20110125114419.139360@gmx.com>
In-Reply-To: <20110125114419.139360@gmx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Josef!

Do you know the chipset, which is used in your card? As far as I can
see, it seems to be a 802.11n-card, which would mean, you need ath9k. As
soon as you know the chipset, check this page:

http://wireless.kernel.org/en/users/Drivers/ath9k#supported_chipsets

If yours is within this list, the device should work.

Kind regards,
Dennis Borgmann

Josef Windorfer schrieb:
> Hi all,
>
> I want to buy the mainboard ZOTAC G41-ITX with an mini PCI express WLAN card.
>
> I have only a few information about the card (from the manufacturer).
> It's an Atheros card with either AzureWave WiFi Modul AW NE771 or AzureWave WiFi AR5 B 91.
>
> Is there a driver support in linux available?
> I'm not realy successful by searching google.
>
> Thanks!
>
> Greets Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

