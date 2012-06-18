Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:35133 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab2FRWb5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 18:31:57 -0400
Received: by weyu7 with SMTP id u7so3989387wey.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2012 15:31:56 -0700 (PDT)
Message-ID: <4FDFAC59.7000801@gmail.com> (sfid-20120619_003201_142118_4A7E2B12)
Date: Tue, 19 Jun 2012 00:31:53 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Erwin Van de Velde <erwin.vandevelde@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: ath9k bug in country domain handling
References: <4FDE1EF5.9030805@gmail.com> <4283314.5zPdis6seJ@sylvesterjr.cmi.ua.ac.be>
In-Reply-To: <4283314.5zPdis6seJ@sylvesterjr.cmi.ua.ac.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/18/2012 02:25 PM, Erwin Van de Velde wrote:

> The output I get is:
> [ 8.931463] ath: EEPROM regdomain: 0x0
> [ 8.931483] ath: EEPROM indicates default country code should be used
> [ 8.931502] ath: doing EEPROM country->regdmn map search
> [ 8.931526] ath: country maps to regdmn code: 0x3a
> [ 8.931544] ath: Country alpha2 being used: US
> [ 8.931561] ath: Regpair used: 0x3a
>
> As I see it, the regdomain is 00 and not US, so why does the ath9k driver
> decide to put me in the US? US should not be the default country code, but

It seems natural to think that 0x0 is a 'neutral' region, far from it.
0x0 is US.

> world reg domain. The preferred solution in my opinion is that the driver
> would require a regdomain to be given if it is not already set by the card.
> Choosing US as a default seems purely random . It would make far more sense to
> have no restricions by default if no regdomain is given and require it as a
> parameter, so everyone can set it correctly to his correct domain. The current
> method not only disallows valid channels to be used, but can also allow for
> legally forbidden channels to be used, which could be even worse.

You didn't read any links of my previous e-mail, please do it.


I can provide you some info how to fix it, out of this mailing list.
Because it's a bit annoying to buy a Atheros  wireless card, and ignore their
programmed values. Manufacturers: yellow stickers are cheap and visible!!!
