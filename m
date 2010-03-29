Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35552 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab0C2V5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 17:57:42 -0400
Received: by pwi5 with SMTP id 5so7084756pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 14:57:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201003292204.37467.chunkeey@googlemail.com>
References: <m3tys0tbhk.fsf@intrepid.localdomain> <43e72e891003291222n5e72a0a5m31dddf2bbf6e06ab@mail.gmail.com>
	<m339zizz4o.fsf@intrepid.localdomain> <201003292204.37467.chunkeey@googlemail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 29 Mar 2010 14:57:21 -0700
Message-ID: <43e72e891003291457m60bbc5adm6b004ebda05ab1b2@mail.gmail.com>
Subject: Re: CRDA and ath5k with no country code in EEPROM
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 29, 2010 at 1:04 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Monday 29 March 2010 21:49:59 Krzysztof Halasa wrote:
>> The other thing is the meaning of country=0 in case of Mikrotik cards
>> (and maybe others). Perhaps they should get them back. I wonder if
>> their drivers break the FCC rules, allowing "0" (=US) cards to use
>> channels restricted in the US.
>
> why should they? You can _easily_ edit the whole eeprom content
> and change the country code to your heart's delight.
>
> Just get a _tool_ called: ath_info and read the instructions how to use it.
> If you have doubts, you can also connect eeprom (24c16) to a i2c-bus and
> reprogram it, it's as simple as that....

I'll note this is out of the scope of what is supported, so if you
muck with ath_info you're on your own.

  Luis
