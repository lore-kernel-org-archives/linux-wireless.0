Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:34188 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbbGKRpq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jul 2015 13:45:46 -0400
Received: by lbnk3 with SMTP id k3so106856566lbn.1
        for <linux-wireless@vger.kernel.org>; Sat, 11 Jul 2015 10:45:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150710235917.GA31592@sesse.net>
References: <20150710235917.GA31592@sesse.net>
Date: Sat, 11 Jul 2015 20:45:44 +0300
Message-ID: <CANUX_P0dNv15DW=ZQDx7rF++vsYC6s8DYoh1ZPhRabE1KONK-A@mail.gmail.com> (sfid-20150711_194549_369610_74C49F0D)
Subject: Re: [BUG] 7260AC microcode hang
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 11, 2015 at 2:59 AM, Steinar H. Gunderson
<sgunderson@bigfoot.com> wrote:
> Hi,
>
> I have a Lenovo X240 with an 7260AC (I upgraded it myself, but it is Lenovo
> branded). This weekend I'm at an event where I run the Wi-Fi myself with
> Cisco gear, mostly 2602i. I've had several instances only today where the
> microcode hangs:

[snip]

> At this point, my Wi-Fi is usually so hosed that I just have to reboot;
> SSH lags etc., and then after a while all networking just hangs.

What kernel are you running?

>
> Now, a different question is why Linux insists on using 2.4 GHz even though
> it's super-congested and the APs have turned down the power significantly
> (you can see it's asked to send at 4 dBm in the log there). But that's a
> different and much broader story :-) (I don't have band-select on.)
>

Not sure. This question should go to the supplicant folks.

> /* Steinar */
> --
> Homepage: http://www.sesse.net/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
