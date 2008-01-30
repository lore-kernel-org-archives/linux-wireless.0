Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47656 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739AbYA3Omw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2008 09:42:52 -0500
Subject: Re: [PATCH, take 3] libertas: clean up association debug messages
From: David Woodhouse <dwmw2@infradead.org>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>
In-Reply-To: <200801300854.38715.hs4233@mail.mn-solutions.de>
References: <200710151255.56358.hs4233@mail.mn-solutions.de>
	 <1201665912.28377.38.camel@shinybook.infradead.org>
	 <200801300854.38715.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 01:42:44 +1100
Message-Id: <1201704165.28377.56.camel@shinybook.infradead.org> (sfid-20080130_144257_010863_DA77493D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 2008-01-30 at 08:54 +0100, Holger Schurig wrote:
> I suddenly saw no activity anymore in libertas-2.6, just later I 
> heard that you were in Mongolia. So I posted my stuff as before.

Yeah, it's going to be a little sporadic. I got the most important
cleanups done for 2.6.25 but there's a bunch left to do, and it's quite
likely that it'll happen largely while I'm locked in tin cans. Having to
pretend we're in the 1990s again instead of using git properly would be
a bit of a PITA. 

I might have to rebase onto Linus' tree (sorry, I know rebasing should
only happen when you fuck up, but I _did_ fuck up, by basing our kernel
development on a fake-git tree instead of a real one). But after that I
think we should probably keep the proper git tree and push it directly
to Linus.

-- 
dwmw2

