Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37918 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab1JOKCC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Oct 2011 06:02:02 -0400
Received: by wwe6 with SMTP id 6so28169wwe.1
        for <linux-wireless@vger.kernel.org>; Sat, 15 Oct 2011 03:02:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-VmonaBUTEKLghg8DJsqUpp6iR-R=pPuejUWwq=ukxt+utzg@mail.gmail.com>
References: <CAN=pzd+TcY+n90RBMU+Cpp0Bt9d_eAGgY4yffO+PSStWSzbf-Q@mail.gmail.com>
	<CAJ-Vmomy-LGg=mh5=GqmqWuj7T8b1+oV3oaBSZpf6orJSGPTQg@mail.gmail.com>
	<CAN=pzd+8wq4Mw3Ww8jTOYNk-Q2EYOvtdgHPi=RMQqbJvJRZtdw@mail.gmail.com>
	<CAJ-VmonaBUTEKLghg8DJsqUpp6iR-R=pPuejUWwq=ukxt+utzg@mail.gmail.com>
Date: Sat, 15 Oct 2011 14:02:00 +0400
Message-ID: <CAN=pzdJiBp742nrgb4eGwRDQO_nBgKNU1v405D_4SwBYPJ3S=A@mail.gmail.com> (sfid-20111015_120209_803194_C4AE29F2)
Subject: Re: Ath9k, single antenna on ar9280
From: Stanislav Demakov <s.demakov@gmail.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks. I'll ask him.

>>both the second and third are connected to chain 1 via
an antenna switch.

That's interesting. Could you give me a clue how to implement this?
Also after doing that, will it be enough to use only one physical
antenna connector?

2011/10/15 Adrian Chadd <adrian@freebsd.org>:
> You'll have to ask Felix and others, but I think they're more generic
> APIs to support things like AR9285 (and the relevant AR9300/AR9400
> series NICs) which implement 1x1 but have "classic" style antenna
> diversity.
>
> Also, as I've discovered, you _can_ glue an antenna switch onto the
> side of a MIMO NIC. Eg, I have an AR9220 based NIC (2x2:2) which has
> three antennas, both the second and third are connected to chain 1 via
> an antenna switch.
>
>
>
> Adrian
>
