Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35065 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252AbbLOMdK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2015 07:33:10 -0500
Message-ID: <1450182788.3356.14.camel@sipsolutions.net> (sfid-20151215_133315_100806_76AC9274)
Subject: Re: [PATCH] nl80211: Potential memory leaks in reg.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Ola Olsson <ola1olsson@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ola Olsson <ola.olsson@sonymobile.com>
Date: Tue, 15 Dec 2015 13:33:08 +0100
In-Reply-To: <CABAco3CgkoCYdHZV6nBfV+CUpD379XR69EiznXvu42p5UC96gw@mail.gmail.com> (sfid-20151215_131934_996381_B65C896A)
References: <1450030323-6637-1-git-send-email-ola1olsson@gmail.com>
	 <1450181385.3356.6.camel@sipsolutions.net>
	 <CABAco3CgkoCYdHZV6nBfV+CUpD379XR69EiznXvu42p5UC96gw@mail.gmail.com>
	 (sfid-20151215_131934_996381_B65C896A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-12-15 at 13:19 +0100, Ola Olsson wrote:
> I'm trying to learn how the code works so I'm reading through it line
> by line. I have seen so many memory leaks in my days so I know where
> to look ;)

Ok :)

> They are indeed obscure since we need an error to actually trigger
> them but I thought I might as well share the info when I found them.

Of course, the patches are very welcome!

I'm just surprised that none of the tools we (and others) typically run
found these, and thought perhaps you had a better tool than we do...
I guess it's called "brain" and we just don't use it right ;-)

johannes
