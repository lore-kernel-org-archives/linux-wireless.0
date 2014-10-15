Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:63201 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaJOVT2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2014 17:19:28 -0400
Received: by mail-wi0-f181.google.com with SMTP id hi2so3045714wib.14
        for <linux-wireless@vger.kernel.org>; Wed, 15 Oct 2014 14:19:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANa-JWyxT0LDwmhS-G=exHbHMipBr51sRyazH9XA5dnUZEjKRw@mail.gmail.com>
References: <CANa-JWyxT0LDwmhS-G=exHbHMipBr51sRyazH9XA5dnUZEjKRw@mail.gmail.com>
Date: Wed, 15 Oct 2014 14:19:27 -0700
Message-ID: <CA++WF2OOatF6z3m8-0rs3oJinQ1HjNj92XOwoTcAvz2OpYShbA@mail.gmail.com> (sfid-20141015_231932_152408_9DF9D95F)
Subject: Re: ipw2200 driver in kernels 3+
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Frank Langille <flangille@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Frank,

On 15 October 2014 12:34, Frank Langille <flangille@gmail.com> wrote:
> ... the menuconfig option to select this
> driver seems to have disappeared sometime after kernel 3.4.104, which
> is the last longterm version I can see that allows me to include the
> driver in my build.
>
> Is it possible to have the option made available again?

Yes it is, to do so you need to enable old wireless extensions support
(CONFIG_CFG80211_WEXT), Network support-> Wireless-> cfg80211 wireless
configuration API -> cfg80211 wireless extension computability.

Stanislav.
