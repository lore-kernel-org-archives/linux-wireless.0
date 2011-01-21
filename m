Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:36506 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903Ab1AUTzp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 14:55:45 -0500
Date: Fri, 21 Jan 2011 11:55:09 -0800
From: Greg KH <greg@kroah.com>
To: Vipin Mehta <vmehta@atheros.com>
Cc: Vipin Mehta <Vipin.Mehta@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"joe@perches.com" <joe@perches.com>
Subject: Re: [PATCH 00/83] staging: ath6kl: Style cleanup
Message-ID: <20110121195509.GB18700@kroah.com>
References: <1295637798-18355-1-git-send-email-vmehta@atheros.com>
 <20110121193830.GA17789@kroah.com>
 <20110121194840.GA18603@vmehta-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110121194840.GA18603@vmehta-desktop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 21, 2011 at 11:48:40AM -0800, Vipin Mehta wrote:
> On Fri, Jan 21, 2011 at 11:38:30AM -0800, Greg KH wrote:
> > On Fri, Jan 21, 2011 at 11:23:18AM -0800, Vipin Mehta wrote:
> > > The following set of patches fixes the driver's coding style in 
> > > accordance with the Linux kernel coding style. The patches ended 
> > > being huge so putting them up on a shared location where they can 
> > > be retrieved using wget.
> > > 
> > > http://userweb.kernel.org/~vmehta/ath6kl-cleanup.tar.bz2
> > 
> > Interesting, however the very first patch fails to apply :(
> 
> I generated the patches after rebasing my tree to the
> remotes/origin/staging-linus in the staging-2.6 tree. I tested it
> again just a whilw back and the patches do apply.

These patches are NOT for staging-linus as they are not to go to him
until the .39 merge window is open, right?  Please rebase them on the
staging-next tree.

thanks,

greg k-h
