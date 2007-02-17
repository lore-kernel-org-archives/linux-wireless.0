Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgate.cesmail.net ([216.154.195.36]:50427 "HELO
	mailgate.cesmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S2993049AbXBQS0P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Feb 2007 13:26:15 -0500
Message-ID: <20070217132614.zfbt6sckkogosss8@webmail.spamcop.net>
Date: Sat, 17 Feb 2007 13:26:14 -0500
From: Pavel Roskin <proski@gnu.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: More breakage in wireless-dev.git
References: <1171690868.31103.17.camel@dv>
	<200702171856.08068.mb@bu3sch.de>
	<20070217131045.tsmois8g0og8okc4@webmail.spamcop.net>
	<200702171914.06802.mb@bu3sch.de>
In-Reply-To: <200702171914.06802.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Michael Buesch <mb@bu3sch.de>:

> On Saturday 17 February 2007 19:10, Pavel Roskin wrote:
> > Awesome!  I'm waiting for your public repository to update so I can test
> your
> > fixes.
>
> I always update that when committing stuff, directly.
> So when you see mail from me "I committed foo", it means it's
> available in the public repository.

Then you are not running git-update-server-info every time from
hooks/post-update.  It needs to be run every time any of the branch heads
changes, i.e. on every git-push.  The git documentation was unclear about it
until recently.

--
Regards,
Pavel Roskin
