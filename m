Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:45100 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaBCWRD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 17:17:03 -0500
Received: by mail-we0-f181.google.com with SMTP id w61so3257636wes.40
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 14:17:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAUTuq9oU7+=_sjcix0WuSUp5_5OVRXK1cJdtRDtR1obaJrV1Q@mail.gmail.com>
References: <CAAUTuq_bgXcfKquXR+ATumO7xkyTE_WLUvUOMZ7bPYCP0_XnuQ@mail.gmail.com>
 <CAJwzM1kzbvy7UnjJerJ8EmUxvp5GYPeKS-9988SgxfoQrv-Zjw@mail.gmail.com>
 <CAAUTuq_LnUCTBaHndBiLDk0ge+055YJJMY4Ni+bV7PrYq_KSHA@mail.gmail.com>
 <CAJwzM1kQJvfZwPi_suBSgCEquAHvYduwRWcM01==nT_TVd0d0g@mail.gmail.com> <CAAUTuq9oU7+=_sjcix0WuSUp5_5OVRXK1cJdtRDtR1obaJrV1Q@mail.gmail.com>
From: Andrew Wiley <wiley.andrew.j@gmail.com>
Date: Mon, 3 Feb 2014 16:16:42 -0600
Message-ID: <CAAUTuq9dcKvGk0PWhP16=yyK79mE-T-1gbGPpd5G__imimHvBQ@mail.gmail.com> (sfid-20140203_231708_333706_04209F28)
Subject: Re: mwifiex and SD8787: TX queue timeout in AP mode
To: Avinash Patil <avinashapatil@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 3, 2014 at 4:02 PM, Andrew Wiley <wiley.andrew.j@gmail.com> wrote:
> On Mon, Feb 3, 2014 at 12:47 AM, Avinash Patil <avinashapatil@gmail.com> wrote:
>> Does this issue happens with station interface as well?
>
> I haven't really made use of station mode much, but I just tried it
> and it seems stable. The first time I tried to connect, the driver had
> a command timeout while scanning and the card dropped out, but the
> second time, it connected and has stayed stable for 30 minutes or so.
> The network I'm connected to uses WPA2. I'll continue to monitor the
> box to see if the queue hangs.
>

A few minutes after I wrote this, the box hung. No kernel errors were
logged in the serial console - it just stopped responding.
I'll have to investigate this further.
