Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:41615 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407AbZKFLRD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 06:17:03 -0500
Received: by bwz27 with SMTP id 27so1025258bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 03:17:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <m3ws246ky4.wl%holgerschurig@gmail.com>
References: <fd145f7d0911060004j55b06482tca088685d0626249@mail.gmail.com>
	 <m3ws246ky4.wl%holgerschurig@gmail.com>
Date: Fri, 6 Nov 2009 12:17:07 +0100
Message-ID: <2da21fe50911060317v55acefdvfac01821b5f9cb0f@mail.gmail.com>
Subject: Re: Getting random regulatory domains on boot-up with ath9k
From: Davide Pesavento <davidepesa@gmail.com>
To: Holger Schurig <holgerschurig@googlemail.com>
Cc: Jeffrey Baker <jwbaker@gmail.com>, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 6, 2009 at 10:50, Holger Schurig
<holgerschurig@googlemail.com> wrote:
>> ath: EEPROM regdomain: 0x37
>> ath: EEPROM indicates we should expect a direct regpair map
>> ath: Country alpha2 being used: AW
>> ath: Regpair used: 0x37
>> cfg80211: Calling CRDA for country: AW
>
> I can confirm this bug on wireless-testing, v2.6.32-rc6-41576-g4408b3b
> with an ath5k card:
>

Confirmed on wireless-testing v2.6.32-rc6-wl-41575-g5e68bfb with an
AR5418 card using ath9k. Also 'iw reg set <country code>' stopped
working. Last known working kernel is v2.6.32-rc5-wl-40584-g9b469da.

[   12.573257] ath: EEPROM regdomain: 0x37
[   12.573259] ath: EEPROM indicates we should expect a direct regpair map
[   12.573262] ath: Country alpha2 being used: AW
[   12.573264] ath: Regpair used: 0x37
[   12.579608] cfg80211: Calling CRDA for country: AW

Regards,
Davide
