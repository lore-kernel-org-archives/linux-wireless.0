Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48242 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab1EUFYx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 May 2011 01:24:53 -0400
Received: by ywe9 with SMTP id 9so1380166ywe.19
        for <linux-wireless@vger.kernel.org>; Fri, 20 May 2011 22:24:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87tycpqw65.fsf@atheros.com>
References: <4DD668F4.6090308@atheros.com>
	<20110520133600.GA10521@suse.de>
	<87tycpqw65.fsf@atheros.com>
Date: Sat, 21 May 2011 08:24:51 +0300
Message-ID: <BANLkTi=ii3yCh02uHXiV7-zLXoNSD0T_cQ@mail.gmail.com> (sfid-20110521_072456_719522_2CBF776A)
Subject: Re: Plan for ath6kl cleanup
From: Dan Carpenter <error27@gmail.com>
To: Kalle Valo <kalle.valo@atheros.com>
Cc: Greg KH <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/20/11, Kalle Valo <kalle.valo@atheros.com> wrote:
>> Don't worry about "cluttering" up the mailing list, send them to me, and
>> to the driver devel mailing list, and I will take them just fine.
>
> I'm talking about linux-wireless mailing list. And yes, I really think
> that sending patches like removing A_MEMSET() is cluttering the mailing
> list. I would rather see wireless hackers doing something productive
> than reading patches like that.
>

Mutt has a short cut to delete a whole thread.  You learn that
quickly enough when you deal with Greg KH.

Anyway, those patches aren't hard to review.  I use a script
for it:
http://marc.info/?l=linux-driver-devel&m=129699522622014&w=2
It strips out the whitespace changes and the pure sed work
and it only shows interesting changes.  You can invoke it
directly from mutt so it takes about 30 seconds to look over
each patch.

I'm not saying that everything should get sent to lkml, but
those patches are fine on the driver devel list.  The rule that
everything should go to a public mailing list is a good one.

regards,
dan carpenter
