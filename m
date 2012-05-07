Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:63521 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757850Ab2EGTkW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 15:40:22 -0400
Received: by gglu4 with SMTP id u4so471567ggl.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 May 2012 12:40:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120506.145304.1998242927519675381.davem@davemloft.net>
References: <1336157988-4602-1-git-send-email-gustavo@padovan.org>
 <20120506.123656.1335354317428258137.davem@davemloft.net> <CANq1E4TTfDxZPsOqqWUT7PqTKUr8nCTC-wo=iGe_pxoUmnecgQ@mail.gmail.com>
 <20120506.145304.1998242927519675381.davem@davemloft.net>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Mon, 7 May 2012 16:40:01 -0300
Message-ID: <CAMOw1v7LGZ9jN3BdRSuw5iBNWUNOff+aaUCcXaz+YShpxjLLHA@mail.gmail.com> (sfid-20120507_214034_857610_8DB06D90)
Subject: Re: [PATCH] Bluetooth: Fix coding style
To: David Miller <davem@davemloft.net>
Cc: dh.herrmann@googlemail.com, gustavo@padovan.org,
	linville@tuxdriver.com, linux-bluetooth@vger.kernel.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 6, 2012 at 3:53 PM, David Miller <davem@davemloft.net> wrote:
> From: David Herrmann <dh.herrmann@googlemail.com>
> Date: Sun, 6 May 2012 19:46:46 +0200
>
>> Whose rules are they?
>
> Find me an example in another major core subsystem, let's use

The ones he pointed out, coming from Linus aren't enough?


> mm/memory.c as an example as that file gets hit by a lot of people,
> that uses the multi-line conditional TAB-only crap you guys seem to
> keep using.

Look again at this file and you'll see there is mixed style.


>
> They don't.  All the examples you'll find are of the form:
>
>        if (a &&
>            b)
>
> not:
>
>        if (a &&
>                        b)
>
> like I see happening in bluetooth all the time.
>
> How did you think they figured that out?  Did they read someone's
> mind?

No, they used the default in emacs or another editor that has this as
default, i.e. mix tabs and spaces


Regards,
Lucas De Marchi
