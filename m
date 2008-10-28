Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:47879 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752250AbYJ1F7H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 01:59:07 -0400
Date: Mon, 27 Oct 2008 22:56:09 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"otus-devel@lists.madwifi-project.org"
	<otus-devel@lists.madwifi-project.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Linux-Kernel <linux-kernel@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Joey Krane <linuxbsd2004@gmail.com>
Subject: Re: [otus-devel] Release of Atheros 802.11n USB Linux driver
Message-ID: <20081028055609.GA6468@kroah.com> (sfid-20081028_065912_891052_94CF7208)
References: <43e72e890810211904x7bd243dem68dfcfe7a795ec6f@mail.gmail.com> <20081022065045.GA2400@kroah.com> <20081023062655.GA8039@kroah.com> <20081023111103.GB5979@tesla> <43e72e890810271635i5b6dd6e4ua06b48e624991435@mail.gmail.com> <20081028002919.GB2992@kroah.com> <20081028005553.GE6377@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081028005553.GE6377@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 27, 2008 at 05:55:53PM -0700, Luis R. Rodriguez wrote:
> 
> Excellent, if no one send patches I guess I will.

Ok, I've now added it to the staging tree and will forward it on to
Linus.  After it gets there you can probably drop the git tree.

> So we have a page for this now:
> 
> http://wireless.kernel.org/en/users/Drivers/otus

You might want to link to this off of the "main" drivers page as well.

> Init you can find a list of devices. Let me just paste what we have
> there now:
> 
> Dlink
> 
>     * DWA-160A1 
> 
> Netgear
> 
>     * WNDA3100
>     * WN111v2 
> 
> TP-Link
> 
>     * TL-WN821N 
> 
> AVM
> 
>     * FRITZ!WLAN N USB Stick (USB ID 0x57c, 0x8401) 

Cool, I'll go poke around the store and see if I can find one of these.

> > I'll go try to get this tree into a buildable state and put it into
> > staging tonight.
> 
> Thanks! BTW if you add a kconfig option for it please point users with
> this info:

Oops, forgot this, I'll go add it.

thanks,

greg k-h
