Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34290 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab1HOO4d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 10:56:33 -0400
Received: by wyg24 with SMTP id 24so3542388wyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 15 Aug 2011 07:56:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313234481.2052.7.camel@localhost.localdomain>
References: <1313234481.2052.7.camel@localhost.localdomain>
Date: Mon, 15 Aug 2011 20:26:32 +0530
Message-ID: <CAD2nsn3c=eR7gx+UG-VZWq7EkRioJcBexPHJXNCF+GfA2WgSog@mail.gmail.com> (sfid-20110815_165643_997523_D6A8765F)
Subject: Re: [ath9k-devel] Packet loss regression with Atheros AR9280
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Jan Sundman <jan.sundman@aland.net>
Cc: robert@ocallahan.org, ath9k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 13, 2011 at 4:51 PM, Jan Sundman <jan.sundman@aland.net> wrote:
> Hi,
>
> I'm not sure whether you have found a solution to this issue yet but I
> thought that I should share my findings. I'm running Arch linux on my
> laptop which have the AR9280 and I saw massive packet loss as well.

is it an in built card?

>
> I noticed however that this _only_ occurred when the laptop was on
> battery power. So it seems to be due to some power save functionality
> for the card.

if its an in built card, then
this looks like a platform issue, if so please use
 http://www.kernel.org/pub/linux/kernel/people/mcgrof/scripts/cpudmalatency.c
 http://johannes.sipsolutions.net/files/netlatency.c.txt

 >
> "iwconfig wlan0 power off" seems to fix it so I added this to my startup
> script and this fixes it. This is of course not a optimal solution but
> may point you in the right direction on fixing the problem.
>
> Br,
>
> /Jan
>
>>On 12 August 2011 10:27, Robert O'Callahan ><robert@ocallahan.org>
> wrote:
>
>>> Anything I can get building with this kernel, I guess. Any particular
>>> version I should try?
>
>>I'd suggest going back a month at a time
>>(http://www.orbit-lab.org/kernel/compat-wireless-2.6/2011/), >try each
>>until you find one that works, then report >"compat-wireless X works,
>>compat-wireless Y doesn't". That'll be a good way to >test multiple
>>copies of the development wireless tree.
>
>>If someone Fedora-clued knows which version(s) of the >wireless code
>>are involved with Robert's good and bad behaviour >reports, that'll
>>also help.
>
>>Anything to kick-start a git bisect :-)
>
>>Ciao,
>
>
>>Adrian
>
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>



-- 
shafi
