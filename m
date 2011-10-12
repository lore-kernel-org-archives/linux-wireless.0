Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54086 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab1JLOhZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 10:37:25 -0400
Date: Wed, 12 Oct 2011 08:36:00 -0600
From: Greg KH <gregkh@suse.de>
To: Arend van Spriel <arend@broadcom.com>
Cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] staging: brcm80211: remove brcm80211 driver from the
 staging tree
Message-ID: <20111012143600.GA17938@suse.de> (sfid-20111012_163728_609952_D55F4BF5)
References: <4E95A1D1.8010602@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E95A1D1.8010602@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 12, 2011 at 04:18:57PM +0200, Arend van Spriel wrote:
> Hi Greg,
> 
> John recommended to do the delete through your staging tree. Thanks for
> the ride. It has been a learning experience for all of us here. Apart
> from the significant cleanup (which needs ongoing work for sure) it took
> some time to find the right way of working in coordinating our changes
> with community patches.
> 
> The removal patch was just as big as the mainline patch so it has been
> uploaded to linuxwireless.org:
> 
> http://linuxwireless.org/en/users/Drivers/brcm80211?action=AttachFile&do=view&target=0001-staging-brcm80211-remove-brcm80211-driver-from-the-s.patch

So I'm taking it that the driver is now in the wireless-next tree?
That's great, I'll queue the patch up later today.

And thanks so much for working with us, I know it can be hard at times,
but I hope you will agree that the end result is much better than what
we started out with.

greg k-h
