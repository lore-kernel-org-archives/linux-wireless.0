Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:59181 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590Ab0IRFfB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Sep 2010 01:35:01 -0400
Date: Fri, 17 Sep 2010 22:12:44 -0700
From: Greg KH <greg@kroah.com>
To: Vipin Mehta <Vipin.Mehta@Atheros.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] staging: ath6kl: Including a header file to fix a
	compilation error
Message-ID: <20100918051244.GB18733@kroah.com>
References: <1284742495-2970-1-git-send-email-vmehta@atheros.com> <4C93A412.2070005@oracle.com> <35B17FE5076C7040809188FBE7913F983F23937DAE@SC1EXMB-MBCL.global.atheros.com> <20100917232643.GA25757@kroah.com> <35B17FE5076C7040809188FBE7913F983F23A27636@SC1EXMB-MBCL.global.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <35B17FE5076C7040809188FBE7913F983F23A27636@SC1EXMB-MBCL.global.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 17, 2010 at 07:00:56PM -0700, Vipin Mehta wrote:
> > 
> > Please, fix your email client to wrap lines at a sane place...
> Do you have any recommendation for the email client? 
> I am using outlook currently.

Anything except outlook (thunderbird, evolution, mutt, etc.)

> > If the problem is due to another change in a different tree, send me the
> > patch and I'll hold on to it until the mmc tree is merged with Linus
> > (during the .37 merge window) and then I'll apply it and push it out.
> > 
> > Until then, we can ask Stephen to hold the patch in linux-next to fix
> > the build issue.
> >
> I have sent out a patch for the linux-next tree that
> fixes the problem. BTW, is there a way I can include
> comments in the patch. How do you establish a context
> between what is discussed in these emails with the
> patches sent to you?

Read Documentation/SubmittingPatches, section 15, for how to do this.

> > But I'd still like the .h file fixup patch to be resolved and in my tree
> > first, right?
> I have sent you the patch.

I got them, I'll process them next week.

thanks,

greg k-h
