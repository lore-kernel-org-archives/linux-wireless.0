Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.224]:24311 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbYIOWGq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 18:06:46 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2352334rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2008 15:06:44 -0700 (PDT)
Message-ID: <2da21fe50809151506p57c9193g6a9e97d682e0064a@mail.gmail.com> (sfid-20080916_000648_621309_B334D940)
Date: Tue, 16 Sep 2008 00:06:44 +0200
From: "Davide Pesavento" <davidepesa@gmail.com>
To: ath9k-devel@lists.ath9k.org
Subject: Re: frustrating ath9k issues
Cc: linux-wireless@vger.kernel.org, jmalinen@atheros.com,
	lrodriguez@atheros.com, "Steven Noonan" <steven@uplinklabs.net>
In-Reply-To: <f488382f0809151450u2f5501cbt14ef9f4ce19a9eb3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <f488382f0809151450u2f5501cbt14ef9f4ce19a9eb3@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/9/15 Steven Noonan <steven@uplinklabs.net>:
>
> More recently, I had another incident where it disassociated and
> refused to reassociate. I got about 100 of these in my dmesg (fixed by
> unloading and reloading ath9k):
>
> [...]
> [ 1279.031033] ath_set_channel: unable to reset channel 149 (5745Mhz)
> flags 0x30142 hal status 4294967277
> [ 1279.031203] ath9k_config: Unable to set channel
> [ 1279.323427] ath_set_channel: unable to reset channel 153 (5765Mhz)
> flags 0x50142 hal status 4294967277
> [ 1279.323577] ath9k_config: Unable to set channel
> [ 1279.624562] ath_set_channel: unable to reset channel 157 (5785Mhz)
> flags 0x30142 hal status 4294967277
> [ 1279.624687] ath9k_config: Unable to set channel
> [ 1279.916441] ath_set_channel: unable to reset channel 161 (5805Mhz)
> flags 0x50142 hal status 4294967277
> [ 1279.916586] ath9k_config: Unable to set channel
> [ 1280.207274] ath_set_channel: unable to reset channel 165 (5825Mhz)
> flags 0x10142 hal status 4294967277
> [ 1280.207387] ath9k_config: Unable to set channel
> [...]
>

I am experiencing this same issue from time to time, too. rmmod ath9k
&& modprobe ath9k fixes it. My card is AR5418 on a MacBook Pro.

Regards,
Davide Pesavento
