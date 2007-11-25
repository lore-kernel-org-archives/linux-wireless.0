Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.226]:60960 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbXKYRau (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2007 12:30:50 -0500
Received: by nz-out-0506.google.com with SMTP id s18so126210nze
        for <linux-wireless@vger.kernel.org>; Sun, 25 Nov 2007 09:30:49 -0800 (PST)
Message-ID: <6995ca080711250930x14a2975ub9b11d9da97639f2@mail.gmail.com> (sfid-20071125_173054_744210_0E5E42FF)
Date: Sun, 25 Nov 2007 12:30:48 -0500
From: "Vadim Peretokin" <vperetokin@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: Belin FD7010 v7
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1195954954.10279.4.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <6995ca080711221239t2947765ds765fd933fce5de31@mail.gmail.com>
	 <1195781993.11966.27.camel@dv>
	 <6995ca080711221804w7310134aw8a5902e45aa09942@mail.gmail.com>
	 <1195784707.11966.38.camel@dv>
	 <6995ca080711230736n54330d30s96831a664d46df1c@mail.gmail.com>
	 <1195879405.7449.62.camel@dv>
	 <6995ca080711241054s4aeca1f9r2496a36f93a9db43@mail.gmail.com>
	 <20071124143310.a7pta1f4lc0k4ok0@webmail.spamcop.net>
	 <6995ca080711241246kbb09472k777c2082a41b692a@mail.gmail.com>
	 <1195954954.10279.4.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I noticed, that was horrid typing. My keyboard is okay though hehe.

And thank you, when will I be able to test the driver again then?

On Nov 24, 2007 8:42 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Sat, 2007-11-24 at 15:46 -0500, Vadim Peretokin wrote:
> > Yes! Yes there was a new_id thing that we used echo on.
> >
> > Here is the output of that command:
> >
> > vadi@vadi-laptop:~$ lspci -n
> [skip]
> > 03:00.0 0200: 1799:701f (rev 20)
>
> I've submitted a patch to add that ID to the driver.  Just for the
> record, it's actually Belkin F5D7010 v7.  You lost "k" and "5" in the
> subject, check your keyboard :)
>
> --
> Regards,
> Pavel Roskin
>
