Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:46257 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab3AUUYD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2013 15:24:03 -0500
Received: by mail-la0-f48.google.com with SMTP id fq13so1529160lab.7
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jan 2013 12:24:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50FDA355.7090400@gmail.com>
References: <E1TwInB-0003VY-Jh@sipsolutions.net> <50FA04B6.8080703@gmail.com>
 <CAB=NE6UHBZhg7L_Oh5EayLBQyY=fceqUBtfz=kEFXG_u2Ko9TQ@mail.gmail.com>
 <20130121200610.GE1432@bombadil.infradead.org> <50FDA355.7090400@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 21 Jan 2013 12:23:40 -0800
Message-ID: <CAB=NE6V7dQrPYkDG648EcrtS0xmpfYiWAUK6WZJGpCXh6Z4V2w@mail.gmail.com> (sfid-20130121_212407_560262_8208A025)
Subject: Re: [ANN] crda: v1.1.3
To: Richard Farina <sidhayn@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 21, 2013 at 12:21 PM, Richard Farina <sidhayn@gmail.com> wrote:
> On 01/21/2013 03:06 PM, Luis R. Rodriguez wrote:
>> diff --git a/reglib.c b/reglib.c
>> index bc81974..1fafd37 100644
>> --- a/reglib.c
>> +++ b/reglib.c
>> @@ -9,6 +9,7 @@
>>  #include <fcntl.h>
>>  #include <stdbool.h>
>>  #include <unistd.h>
>> +#include <string.h>
>>
>>  #include <arpa/inet.h> /* ntohl */
>
> This patch fixes the warnings, thank you.
>
> Normally warnings are not a big deal, but often they later become errors
> so I figured it was worth reporting. Glad to see it fixed ;-)

I'll commit this but not as a fix as its doesn't fix anything but a
compile warning. It'll be part of v1.1.4 (or guess v3.8-rc$(something)
to keep in line with the kernel releases as iw does now, thanks for
reporting!

  Luis
