Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65340 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab1DKJyM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 05:54:12 -0400
Received: by fxm17 with SMTP id 17so3445146fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2011 02:54:11 -0700 (PDT)
Message-ID: <4DA2CFC0.8000606@googlemail.com>
Date: Mon, 11 Apr 2011 11:54:08 +0200
From: Dennis Borgmann <dennis.borgmann@googlemail.com>
MIME-Version: 1.0
To: Roberto Riggio <roberto.riggio@create-net.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: Channels 12-13 in europe
References: <4DA2CD1A.3040309@create-net.org>
In-Reply-To: <4DA2CD1A.3040309@create-net.org>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Roberto!

Did you do EVERYTHING as described on this page:

http://acx100.erley.org/stable.html

I once had a similar error as you have, which was due to not having
installed crda, if I remember correctly.

Just a thought of mine.

Best regards,
Dennis

Roberto Riggio schrieb:
> Hi,
>
> I'm using openwrt with the latest compat wireless. Is an ath9k supported
> wireless NIC supposed to work over channel 12 and 13 if the country code
> is set to IT?
>
> If I run:
>
> iw phy phy0 info
>
> tis is what i get:
>
>         Frequencies:
>             * 2412 MHz [1] (20.0 dBm)
>             * 2417 MHz [2] (20.0 dBm)
>             * 2422 MHz [3] (20.0 dBm)
>             * 2427 MHz [4] (20.0 dBm)
>             * 2432 MHz [5] (20.0 dBm)
>             * 2437 MHz [6] (20.0 dBm)
>             * 2442 MHz [7] (20.0 dBm)
>             * 2447 MHz [8] (20.0 dBm)
>             * 2452 MHz [9] (20.0 dBm)
>             * 2457 MHz [10] (20.0 dBm)
>             * 2462 MHz [11] (20.0 dBm)
>             * 2467 MHz [12] (disabled)
>             * 2472 MHz [13] (disabled)
>             * 2484 MHz [14] (disabled)
>
> Actually, I get the same even if I set the country code to JP,where also
> channel 14 should be supported.
>
> Thanks
>

