Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:33440 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932297AbcKPEp3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 23:45:29 -0500
Received: by mail-it0-f67.google.com with SMTP id c20so4943086itb.0
        for <linux-wireless@vger.kernel.org>; Tue, 15 Nov 2016 20:45:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1479202467.12007.26.camel@sipsolutions.net>
References: <CAGp19xcg1qCP3+JNbuiB7Hx=UjLN7KP55wVJT0sKV-iE12501A@mail.gmail.com>
 <1477286912.4085.1.camel@sipsolutions.net> <CAGp19xdgsoyx9Sa=uas1OEiFoJdzFChmt20++9e7fJK=Z1ujWQ@mail.gmail.com>
 <1477379678.4390.2.camel@sipsolutions.net> <CAJ-Vmon0RTAXJMuwANCO23cPsFyFZ17sAHoReuGBG1u1Q9kK6w@mail.gmail.com>
 <1477461362.4059.17.camel@sipsolutions.net> <CAJ-Vmo=OM=rx-RM0fg=0dY9Jy_9njsFCnuXEPEngrFDj40-mBg@mail.gmail.com>
 <1479202467.12007.26.camel@sipsolutions.net>
From: Adrian Chadd <adrian@freebsd.org>
Date: Tue, 15 Nov 2016 20:45:27 -0800
Message-ID: <CAJ-Vmomo-1jyScPS_ecKViMo-waMAxG=FuGEOH2C49C1fthN1w@mail.gmail.com> (sfid-20161116_054533_033780_B0BD4C64)
Subject: Re: Bayesian rate control
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?UTF-8?Q?Bj=C3=B6rn_Smedman?= <bjornsmedman@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 November 2016 at 01:34, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>> But there is a per-descriptor TX rate table entry in the driver.
>> FreeBSD uses it to implement its rate control for the intel drivers.
>>
>> What am I missing? :)
>
> Not sure. But there isn't a per-descriptor table in the driver. There's
> a per-station table, that *can* be used in similar ways, but at least
> in Linux none of the APIs are hooked up to the general implementation,
> it's all driver/device-specific code, so it'd be very painful to try to
> experiment with.

Ok. well, we do that. :)

I'll let you know how well it works when I'm doing 11ac with the 7260 driver.



-adrian
