Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52448 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbZFSSPb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 14:15:31 -0400
Date: Fri, 19 Jun 2009 14:02:34 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dave <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Subject: Re: [PATCH 21/23] orinoco: convert scanning to cfg80211
Message-ID: <20090619180233.GD2753@tuxdriver.com>
References: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com> <1245363695-8289-22-git-send-email-kilroyd@googlemail.com> <20090619173541.GC2753@tuxdriver.com> <4A3BD06D.7080702@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4A3BD06D.7080702@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 19, 2009 at 06:52:45PM +0100, Dave wrote:
> John W. Linville wrote:
> > On Thu, Jun 18, 2009 at 11:21:33PM +0100, David Kilroy wrote:
> >> This removes the custom scan cache used by orinoco.
> >>
> >> We also have to avoid calling cfg80211_scan_done from the hard
> >> interrupt, so we offload the entirety of scan processing to a workqueue.
> >>
> >> This may behave strangely if you start scanning just prior to
> >> suspending...
> >>
> >> Signed-off-by: David Kilroy <kilroyd@googlemail.com>
> > 
> > Hmmm...please do try to compile test patches before posting! :-)
> > 
> > John
> 
> Compile? I'm running it! (and sparse didn't complain either)
> 
> I'll go have a look see what's special on my end. I'm guessing no SMP or
> something.

Haha...yeah, that's probably it...

> Would you like the series/patch reposted including this fix?

No, I've got it fixed.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
