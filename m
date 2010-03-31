Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:39939 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091Ab0CaRmd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Mar 2010 13:42:33 -0400
Received: by bwz1 with SMTP id 1so268587bwz.21
        for <linux-wireless@vger.kernel.org>; Wed, 31 Mar 2010 10:42:32 -0700 (PDT)
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Lorna =?utf-8?Q?Gonz=C3=A1lez?= <lorna.glez@gmx.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Power Save for ath9k
References: <20100330155834.56510@gmx.net>
	<43e72e891003300925s59def37exd515374c34ca73f@mail.gmail.com>
	<20100330171040.56500@gmx.net>
	<43e72e891003301102i5e8ba846le9e9e76d5e1d4215@mail.gmail.com>
	<20100331083822.203290@gmx.net>
	<g2o43e72e891003310858ld1ba635fh67342202ddd76f97@mail.gmail.com>
	<u2g43e72e891003310908hd796bee1w45f9d5d2364be41d@mail.gmail.com>
	<20100331162442.274220@gmx.net>
	<o2x43e72e891003310932ucfb1783aj10674bb09ab3306@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 31 Mar 2010 20:42:29 +0300
In-Reply-To: <o2x43e72e891003310932ucfb1783aj10674bb09ab3306@mail.gmail.com> (Luis R. Rodriguez's message of "Wed\, 31 Mar 2010 09\:32\:02 -0700")
Message-ID: <87aatojsl6.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@gmail.com> writes:

>> I have an Atheros AR928X and today I install the linux version 2.6.34 and iw 0.9.19. but still does not work.
>>
>> when I use iw phy phy1 info I get:
>> Capabilities: SM Power Save disabled
>> I can set power on/off but no period or timeout.
>
> Not sure what this period thing is, can't make it out from the man page.
>
>        power  Used to manipulate power management scheme parameters and mode.
>               To  set  the  period between wake ups, enter period
> `value'.

Most probably it means how many beacons will be skipped by staying
asleep.

-- 
Kalle Valo
