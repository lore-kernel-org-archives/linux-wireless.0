Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43637 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758600Ab0HECVS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Aug 2010 22:21:18 -0400
Received: by wwj40 with SMTP id 40so7237360wwj.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Aug 2010 19:21:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20100805T025322-892@post.gmane.org>
References: <loom.20100805T020816-848@post.gmane.org> <loom.20100805T025322-892@post.gmane.org>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Thu, 5 Aug 2010 12:20:57 +1000
Message-ID: <AANLkTikcWNzO7tbheeJp=NYMsY=Kh983DrR2P=OKCJ5p@mail.gmail.com>
Subject: Re: ath5k : Channel 149 thru 161 not working with
	compat-wireless-2.6.34.1
To: Gopal Raman <graman@arubanetworks.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I found issues when switching to ath5k where the wrong antenna was selected.

Try forcing the antenna (especially if you don't have 1 of them
plugged in) and see how you go:
http://www.mail-archive.com/ath5k-devel@lists.ath5k.org/msg02979.html

Cheers,

--
Jonathan Guerin



On Thu, Aug 5, 2010 at 10:57 AM, Gopal Raman <graman@arubanetworks.com> wrote:
>
>
>>
>
> Gopal Raman <graman@...> writes:
>
> Another piece of information is that when the channel is set to 149, 'cat
> /proc/interrupts' hardly increments whereas on channel 36 it goes up
> real fast. Also 'iw ph0 info' does show that channels 149 thru 161
> in its output.
> -gopal
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
