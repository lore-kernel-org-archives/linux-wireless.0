Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:45461 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab1AUVRb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 16:17:31 -0500
Date: Fri, 21 Jan 2011 13:16:25 -0800
From: Greg KH <greg@kroah.com>
To: Vipin Mehta <vmehta@atheros.com>
Cc: Vipin Mehta <Vipin.Mehta@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"joe@perches.com" <joe@perches.com>
Subject: Re: [PATCH 00/83] staging: ath6kl: Style cleanup
Message-ID: <20110121211625.GA15966@kroah.com>
References: <1295637798-18355-1-git-send-email-vmehta@atheros.com>
 <20110121193830.GA17789@kroah.com>
 <20110121194840.GA18603@vmehta-desktop>
 <20110121195509.GB18700@kroah.com>
 <20110121200907.GA18651@vmehta-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110121200907.GA18651@vmehta-desktop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 21, 2011 at 12:09:07PM -0800, Vipin Mehta wrote:
> On Fri, Jan 21, 2011 at 11:55:09AM -0800, Greg KH wrote:
> > On Fri, Jan 21, 2011 at 11:48:40AM -0800, Vipin Mehta wrote:
> > > On Fri, Jan 21, 2011 at 11:38:30AM -0800, Greg KH wrote:
> > > > On Fri, Jan 21, 2011 at 11:23:18AM -0800, Vipin Mehta wrote:
> > > > > The following set of patches fixes the driver's coding style in 
> > > > > accordance with the Linux kernel coding style. The patches ended 
> > > > > being huge so putting them up on a shared location where they can 
> > > > > be retrieved using wget.
> > > > > 
> > > > > http://userweb.kernel.org/~vmehta/ath6kl-cleanup.tar.bz2
> > > > 
> > > > Interesting, however the very first patch fails to apply :(
> > > 
> > > I generated the patches after rebasing my tree to the
> > > remotes/origin/staging-linus in the staging-2.6 tree. I tested it
> > > again just a whilw back and the patches do apply.
> > 
> > These patches are NOT for staging-linus as they are not to go to him
> > until the .39 merge window is open, right?  Please rebase them on the
> > staging-next tree.
> >
> The only difference in ath6kl between the staging-linus and staging-next 
> is the following patch that was applied yesterday in the staging-linus 
> branch:
> 
> http://git.kernel.org/?p=linux/kernel/git/gregkh/staging-2.6.git;a=commit;h=64911e4b133ff633563d6dd2b021fa1ca0608992
> 
> The reason I used staging-linus is because I wanted to apply these 
> patches on top of the above patch which we will have to do eventually. 

That's nice, but not how I can do things, sorry.

> We will have to go through the pain later which I already went through 
> yesterday while redoing these patches on top of the above one. Is it 
> possible for you to apply the commit 
> 64911e4b133ff633563d6dd2b021fa1ca0608992 
> before applying this series?

No, I don't want to apply the same patch to 2 different branches.  When
that patch is in Linus's tree, then I will worry about merging them
together, but that's something I do all the time, and not a big deal.

I need this series against the proper branch, if I am going to be able
to apply them.

Otherwise I will gladly just ignore them, which is not what I think you
or Joe wants...

thanks,

greg k-h
