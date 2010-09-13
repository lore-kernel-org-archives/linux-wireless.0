Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:38980 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab0IMPtf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Sep 2010 11:49:35 -0400
Date: Mon, 13 Sep 2010 08:42:27 -0700
From: Greg KH <greg@kroah.com>
To: Mike Rapoport <mike@compulab.co.il>
Cc: Henry Ptasinski <henryp@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: Re: [ANN] Full-source Broadcom wireless driver for 11n chips
Message-ID: <20100913154227.GB24563@kroah.com>
References: <20100908150322.17dac9c3@nehalam>
 <20100908225132.GA12490@kroah.com>
 <4C88F8CE.5090708@broadcom.com>
 <4C8DD9F4.5090305@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4C8DD9F4.5090305@compulab.co.il>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 13, 2010 at 09:59:48AM +0200, Mike Rapoport wrote:
> Hi Henry,
> 
> Henry Ptasinski wrote:
> >Broadcom would like to announce the initial release of a fully-open
> >Linux driver for it's latest generation of 11n chipsets.  The driver,
> >while still a work in progress, is released as full source and uses the
> >native mac80211 stack.   It supports multiple current chips (BCM4313,
> >BCM43224, BCM43225) as well as providing a framework for supporting
> >additional chips in the future, including mac80211-aware embedded chips.
> >  The README and TODO files included with the sources provide more
> >details about the current feature set, known issues, and plans for
> >improving the driver.
> >
> >The driver is currently available in staging-next git tree, available at:
> >
> >    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git
> >
> >
> >in the drivers/staging/brcm80211 directory.
> 
> Are there any plans to support BCM4319 and BCM4329 SDIO chipsets?

I think those are supported by the broadcom driver in the android kernel
trees, right?  If so, yes, there are plans for merging them into the
main kernel tree, and any help you can provide would be appreciated.

thanks,

greg k-h
