Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:36764 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbZETIho convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 04:37:44 -0400
Received: by bwz22 with SMTP id 22so258998bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 20 May 2009 01:37:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a8e1da0905192221y449e9820x63d46a6dcbfc1dfc@mail.gmail.com>
References: <a8e1da0905192221y449e9820x63d46a6dcbfc1dfc@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 20 May 2009 10:37:24 +0200
Message-ID: <69e28c910905200137o4e501ed2r65b5b79a1b5a087e@mail.gmail.com>
Subject: Re: b43 lp-phy status
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 20, 2009 at 7:21 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
> Hi, michael
>
> What's the status of b43 for lp-phy? Is is possible to use it with
> basic functionality now?
>
> I have such wireless dev in my dell 5400 laptop.
>
> Now I just use the broadcom hybrid driver which can not pass building
> in latest kernel by default. I make some change to it's wl_linux.c to
> make it compiled. Although the wl.ko works, it has some nasty bug
> which will be triggered after modprobe the module several times.
>
> Could you tell what I can do for the b43 lpy? ie. some testing?

Unfortunately no substantial code additions related to LP have been
checked in so far - the reverse engineering is complete, but Michael
is the only person working on converting the specs to code, and he's
too busy to work on LP.

(Should someone send me a Dell 1395, I could probably start working on
it, but I'm busy with zd1211rw & iwlagn right now.)

>
> --
> Regards
> dave
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
