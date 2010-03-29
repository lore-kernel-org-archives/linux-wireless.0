Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:56487 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab0C2UEp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 16:04:45 -0400
Received: by bwz1 with SMTP id 1so3870260bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 13:04:44 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: CRDA and ath5k with no country code in EEPROM
Date: Mon, 29 Mar 2010 22:04:36 +0200
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
References: <m3tys0tbhk.fsf@intrepid.localdomain> <43e72e891003291222n5e72a0a5m31dddf2bbf6e06ab@mail.gmail.com> <m339zizz4o.fsf@intrepid.localdomain>
In-Reply-To: <m339zizz4o.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003292204.37467.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 29 March 2010 21:49:59 Krzysztof Halasa wrote:
> The other thing is the meaning of country=0 in case of Mikrotik cards
> (and maybe others). Perhaps they should get them back. I wonder if
> their drivers break the FCC rules, allowing "0" (=US) cards to use
> channels restricted in the US.

why should they? You can _easily_ edit the whole eeprom content
and change the country code to your heart's delight.

Just get a _tool_ called: ath_info and read the instructions how to use it.
If you have doubts, you can also connect eeprom (24c16) to a i2c-bus and
reprogram it, it's as simple as that....

Regards,
	Chr
