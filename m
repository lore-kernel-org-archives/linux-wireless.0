Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50832 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab0HWXTV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 19:19:21 -0400
Received: by iwn5 with SMTP id 5so3937243iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Aug 2010 16:19:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimq7nB-ea1XmORprBiS2B-OBNtEiiQXAZLzZfA2@mail.gmail.com>
References: <AANLkTimq7nB-ea1XmORprBiS2B-OBNtEiiQXAZLzZfA2@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 23 Aug 2010 16:19:01 -0700
Message-ID: <AANLkTi=i_7oMX4nTiWwcjGezv8vG92gX_8UV1tv_KdYL@mail.gmail.com>
Subject: Re: ath9k: freeze when putting interface up
To: =?UTF-8?Q?Bj=C3=B8rnar_Hansen?= <tilbjornar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Satagopan Kanthadai <Satagopan.Kanthadai@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 22, 2010 at 8:57 AM, Bjørnar Hansen <tilbjornar@gmail.com> wrote:
> Good morning
>
> With kernel 2..6.35.2 my computer locks up when doing
>  # ifconfig wlan0 up

What chipset do you have? You can find this from dmesg after loading ath9k.

> I have now installed compat-wireless (2010-08-20), and no longer have
> this problem.
> I use the ath9k driver.
>
> As this is a pretty serious problem (machine freezes completely),
> would it be possible to pull some patches from compat-wireless into
> the next point release of 2.6.35?

Absolutely, if we can determine what happened. First we need to reproduce.

 Luis
