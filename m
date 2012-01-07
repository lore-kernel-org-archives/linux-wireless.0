Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51459 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab2AGBp6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jan 2012 20:45:58 -0500
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1RjLM3-0000bD-6Y
	for linux-wireless@vger.kernel.org; Fri, 06 Jan 2012 20:45:55 -0500
Received: from linville-8530p.local (linville-8530p.local [127.0.0.1])
	by linville-8530p.local (8.14.4/8.14.4) with ESMTP id q071ioF4025826
	for <linux-wireless@vger.kernel.org>; Fri, 6 Jan 2012 20:44:50 -0500
Received: (from linville@localhost)
	by linville-8530p.local (8.14.4/8.14.4/Submit) id q071inWp025824
	for linux-wireless@vger.kernel.org; Fri, 6 Jan 2012 20:44:49 -0500
Date: Fri, 6 Jan 2012 20:44:49 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: Your new feature should not be enabled by default! --
 [torvalds@linux-foundation.org: Re: [GIT] Networking]
Message-ID: <20120107014449.GF12127@tuxdriver.com> (sfid-20120107_024601_659034_42839986)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Words of wisdom...

----- Forwarded message from Linus Torvalds <torvalds@linux-foundation.org> -----

> Date: Fri, 6 Jan 2012 17:34:39 -0800
> From: Linus Torvalds <torvalds@linux-foundation.org>
> To: David Miller <davem@davemloft.net>
> Cc: akpm@linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
> Subject: Re: [GIT] Networking
> 
> On Thu, Jan 5, 2012 at 4:28 PM, David Miller <davem@davemloft.net> wrote:
> >
> > Netlink socket dumping is now supported for UDP and AF_UNIX sockets
> > thanks to Pavel Emelyanov.
> 
> .. and this is such a magically important feature that it has to be
> enabled by default?
> 
> It's something that has never been supported before, how did it
> suddenly become 'default y' after twenty years of not even being an
> issue?
> 
> It's a disease, I tell you, to think that new features are important.
> Stop it. Tell people you take patches from to stop it. If we haven't
> needed them before, they sure as hell aren't suddenly "Say Yes if you
> don't know" material.
> 
> Please fix this, but more importantly, please try to fix *people*. So
> I don't have to always react to the stupid new "default y" options.
> 
>                               Linus
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

----- End forwarded message -----

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
