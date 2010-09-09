Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50234 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab0IIPoo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 11:44:44 -0400
Date: Thu, 9 Sep 2010 08:42:18 -0700
From: "John W. Linville" <linville@tuxdriver.com>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Subject: Re: [ANN] Full-source Broadcom wireless driver for 11n chips
Message-ID: <20100909154217.GA2694@tuxdriver.com>
References: <20100908150322.17dac9c3@nehalam>
 <20100908225132.GA12490@kroah.com>
 <4C88F8CE.5090708@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4C88F8CE.5090708@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 09, 2010 at 08:10:06AM -0700, Henry Ptasinski wrote:
> Broadcom would like to announce the initial release of a fully-open
> Linux driver for it's latest generation of 11n chipsets.  The driver,
> while still a work in progress, is released as full source and uses the
> native mac80211 stack.   It supports multiple current chips (BCM4313,
> BCM43224, BCM43225) as well as providing a framework for supporting
> additional chips in the future, including mac80211-aware embedded chips.
>   The README and TODO files included with the sources provide more
> details about the current feature set, known issues, and plans for
> improving the driver.
> 
> The driver is currently available in staging-next git tree, available at:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git
> 
> in the drivers/staging/brcm80211 directory.

Obviously we are all thrilled to see Broadcom take this step, which
I know involved a lot of soul-searching within their organization. :-)

I hope we can use this as a base for productive cooperation between
Broadcom's wireless folks and the greater Linux community for along
time to come!

John

P.S.  I knew that January 2007 meeting in London was good for something... :-)
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
