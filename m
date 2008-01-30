Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756799AbYA3Owo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2008 09:52:44 -0500
Subject: Re: [PATCH, take 3] libertas: clean up association debug messages
From: Dan Williams <dcbw@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
In-Reply-To: <1201704165.28377.56.camel@shinybook.infradead.org>
References: <200710151255.56358.hs4233@mail.mn-solutions.de>
	 <1201665912.28377.38.camel@shinybook.infradead.org>
	 <200801300854.38715.hs4233@mail.mn-solutions.de>
	 <1201704165.28377.56.camel@shinybook.infradead.org>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 09:51:23 -0500
Message-Id: <1201704683.26842.2.camel@localhost.localdomain> (sfid-20080130_145255_144086_54BD3A2F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-01-31 at 01:42 +1100, David Woodhouse wrote:
> On Wed, 2008-01-30 at 08:54 +0100, Holger Schurig wrote:
> > I suddenly saw no activity anymore in libertas-2.6, just later I 
> > heard that you were in Mongolia. So I posted my stuff as before.
> 
> Yeah, it's going to be a little sporadic. I got the most important
> cleanups done for 2.6.25 but there's a bunch left to do, and it's quite
> likely that it'll happen largely while I'm locked in tin cans. Having to
> pretend we're in the 1990s again instead of using git properly would be
> a bit of a PITA. 
> 
> I might have to rebase onto Linus' tree (sorry, I know rebasing should
> only happen when you fuck up, but I _did_ fuck up, by basing our kernel
> development on a fake-git tree instead of a real one). But after that I
> think we should probably keep the proper git tree and push it directly
> to Linus.

Um, wtf?  Wireless patches still go through Linville.  Not to Linus.
I'm not sure why Libertas is special here.  Just because people aren't
using git the way you like to use git isn't an excuse.

Dan


