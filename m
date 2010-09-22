Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41932 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140Ab0IVTJo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 15:09:44 -0400
Received: by fxm12 with SMTP id 12so278498fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Sep 2010 12:09:43 -0700 (PDT)
Message-ID: <4C9A5471.2090009@gmail.com>
Date: Wed, 22 Sep 2010 21:09:37 +0200
From: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org,
	mcgrof@infradead.org
Subject: Re: [PATCH 3/4] compat: move pmcia backport code into compat-2.6.36.h
References: <1284918131-32065-1-git-send-email-hauke@hauke-m.de> <1284918131-32065-3-git-send-email-hauke@hauke-m.de> <4C9A34FB.5020809@gmail.com> <AANLkTinJG=mgYE-eUmptCVkXDDpSB9YDHA0AwbYi7xfw@mail.gmail.com>
In-Reply-To: <AANLkTinJG=mgYE-eUmptCVkXDDpSB9YDHA0AwbYi7xfw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



As on 2010-09-22 18:59, Luis R. Rodriguez did write:
> On Wed, Sep 22, 2010 at 9:55 AM, Kshitij Kulshreshtha
> <kkhere.geo@gmail.com> wrote:
>> Hello,
>>
>> As on 2010-09-19 19:42, Hauke Mehrtens did write:
>>> We have all out backport headers in include/linux/compat-2.6.XX.h also the pcmcia
>>> part there.
>>
>> I'm not sure if this won't make all the compat-wireless modules depend
>> on pcmcia.ko for kernels < 2.6.36 where
>> pcmcia_access_configuation_register() is exported. Even if someone is
>> only building selected drivers like iwlwifi or ath.
> 
> Have you tried loading ath9k or iwlagn on compat-wireless? Did you
> note compat doesn't get loaded? Anyway, patches welcomed to enhance
> this if your concern is if your kernel won't build with this. We also
> plan on dropping PCMCIA completely anyway.

Actually compat does get loaded since mac80211 needs it for noop_llseek
on 2.6.34, however my current build is not showing the pcmcia dependency
that I was afraid of, so please ignore this.

Thanks.
-- 
Kshitij Kulshreshtha

Institut für Mathematik,
Universität Paderborn,
Warburger Straße 100,
33098 Paderborn.

Büro: A3.235

Privatanschrift:
Arnikaweg 62
33100 Paderborn.
