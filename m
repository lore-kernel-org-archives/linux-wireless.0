Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:57709 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756639Ab1CAPsX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 10:48:23 -0500
Date: Tue, 1 Mar 2011 10:48:40 -0500
From: Greg KH <greg@kroah.com>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 2/2] staging: brcm80211: Remove unused variables and
 code clean up
Message-ID: <20110301154840.GA27312@kroah.com>
References: <1298840055-5044-1-git-send-email-martinez.javier@gmail.com>
 <1298840055-5044-2-git-send-email-martinez.javier@gmail.com>
 <20110301031151.GA7620@kroah.com>
 <AANLkTi=zU-F=y2qn6B90F3esbNVkE6_nCOZS-dnTA4en@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTi=zU-F=y2qn6B90F3esbNVkE6_nCOZS-dnTA4en@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 01, 2011 at 04:37:55PM +0100, Javier Martinez Canillas wrote:
> >> ---
> >>  drivers/staging/brcm80211/brcmsmac/wlc_mac80211.c |    9 ---------
> >
> > This doesn't apply anymore, care to redo it and resend?
> >
> > thanks,
> 
> Sure Greg but I tried with today linux-next and the patch applies
> cleanly. Maybe the problem are some patches that you have but haven't
> reached linux-next yet.
> 
> Do you want me to wait a few days to redo and resend it or am I doing
> something wrong?

I applied all of these patches while on a very long plane flight, and
didn't get them to git.kernel.org until after the linux-next pulls
happened for todays linux-next.

So try it tomorrow, all of the changes should be there then and you
should be able to regenerate it then.

If not, please let me know.

Or, you can always work off of the staging-next branch of the
staging-2.6 tree in my git tree if you don't want to use linux-next,
it's your choice.

thanks,

greg k-h
