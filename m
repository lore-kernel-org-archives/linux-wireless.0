Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:45389 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbZCVKdn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 06:33:43 -0400
Received: by bwz17 with SMTP id 17so1377348bwz.37
        for <linux-wireless@vger.kernel.org>; Sun, 22 Mar 2009 03:33:40 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] staging wireless crap: tell people not to work on it
References: <1237714803.5100.770.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 22 Mar 2009 12:33:37 +0200
In-Reply-To: <1237714803.5100.770.camel@johannes.local> (Johannes Berg's message of "Sun\, 22 Mar 2009 10\:40\:03 +0100")
Message-ID: <87ocvtg83i.fsf@litku.valot.fi> (sfid-20090322_113349_726764_37F31345)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Any objections from anyone on this? We've had somebody clean out otus
> because he thought it was a good idea...
>
> johannes
> ---
>  drivers/staging/at76_usb/TODO  |    4 ++--
>  drivers/staging/otus/TODO      |    7 +++----
>  drivers/staging/rt2860/TODO    |    4 ++--
>  drivers/staging/rt2870/TODO    |    9 ++++++++-
>  drivers/staging/wlan-ng/README |    4 +++-
>  5 files changed, 18 insertions(+), 10 deletions(-)
>
> --- wireless-testing.orig/drivers/staging/at76_usb/TODO	2009-03-22 10:31:37.000000000 +0100
> +++ wireless-testing/drivers/staging/at76_usb/TODO	2009-03-22 10:31:37.000000000 +0100
> @@ -1,2 +1,2 @@
> -rewrite the driver to use the proper in-kernel wireless stack
> -instead of using its own.
> +Work on at76c50x-usb instead, possibly using
> +this driver as a reference.

I already sent a similar patch to Greg:

http://kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-05-staging/staging-at76_usb-mention-mac80211-port-in-todo-file.patch

But there's no mention of at76c50x-usb. I'll send an updated version
to him.

(I hope this mail manages to go to the linux-wireless list. All my
emails from yesterday got lost for some strange reason.)

-- 
Kalle Valo
