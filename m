Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:57741
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030246AbXBQSab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Feb 2007 13:30:31 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: More breakage in wireless-dev.git
Date: Sat, 17 Feb 2007 19:30:10 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <1171690868.31103.17.camel@dv> <200702171914.06802.mb@bu3sch.de> <20070217132614.zfbt6sckkogosss8@webmail.spamcop.net>
In-Reply-To: <20070217132614.zfbt6sckkogosss8@webmail.spamcop.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702171930.10830.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 17 February 2007 19:26, Pavel Roskin wrote:
> Quoting Michael Buesch <mb@bu3sch.de>:
> 
> > On Saturday 17 February 2007 19:10, Pavel Roskin wrote:
> > > Awesome!  I'm waiting for your public repository to update so I can test
> > your
> > > fixes.
> >
> > I always update that when committing stuff, directly.
> > So when you see mail from me "I committed foo", it means it's
> > available in the public repository.
> 
> Then you are not running git-update-server-info every time from
> hooks/post-update.  It needs to be run every time any of the branch heads
> changes, i.e. on every git-push.  The git documentation was unclear about it
> until recently.

Uh, why? I thought it is just an optimization and
git walks the tree, if the server info is not updated.

But I ran it manually now.

-- 
Greetings Michael.
