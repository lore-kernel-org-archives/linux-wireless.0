Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44775 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab1B1UPq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 15:15:46 -0500
Date: Mon, 28 Feb 2011 15:13:57 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	George <george0505@realtek.com>, linux-next@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: usb parts should depend on CONFIG_USB
Message-ID: <20110228201357.GF2515@tuxdriver.com>
References: <alpine.DEB.2.00.1102171354200.16788@ayla.of.borg>
 <1298922500-21632-1-git-send-email-linville@tuxdriver.com>
 <1298923731.10109.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1298923731.10109.0.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 28, 2011 at 09:08:51PM +0100, Johannes Berg wrote:
> On Mon, 2011-02-28 at 14:48 -0500, John W. Linville wrote:
> >  
> > +ifeq ($(CONFIG_USB),y)
> > +rtlwifi-objs	+= usb.o
> > +endif
> 
> That reads weird, shouldn't
> 
> rtlwifi-$(CONFIG_USB) += usb.o
> 
> do? Or more likely actually use CONFIG_RTL8192CU?

Maybe...really just following what Larry already had there for pci...?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
