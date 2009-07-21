Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2134 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbZGUUAu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2009 16:00:50 -0400
Subject: Re: [PATCH 3/3] MAINTAINERS: add wl1251 wireless driver
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com, luciano.coelho@nokia.com,
	Reinette Chatre <reinette.chatre@intel.com>,
	James Ketrenos <jketreno@linux.intel.com>,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <87ocrdsu9f.fsf@litku.valot.fi>
References: <20090721191136.22374.69017.stgit@tikku>
	 <20090721191154.22374.17349.stgit@tikku>
	 <1248204540.31365.275.camel@Joe-Laptop.home>
	 <87ocrdsu9f.fsf@litku.valot.fi>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 12:59:22 -0700
Message-Id: <1248206362.31365.292.camel@Joe-Laptop.home>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-07-21 at 22:36 +0300, Kalle Valo wrote:
> Joe Perches <joe@perches.com> writes:
> 
> >> +F:	drivers/net/wireless/wl12xx/wl1251*
> >
> > Not that I'm asking you to maintain more than you want to,
> > but why not:
> >
> > F:	drivers/net/wireless/wl12xx/
> 
> Just because Luciano will soon publish wl1271 driver (which will use
> wl1271_ prefix) and he will be maintaining that part, no other reason.

Ah, thanks.

> But what should we do with the shared Makefile and Kconfig?

Those files change slowly and generally without conflicts
so MAINTAINERS entries aren't an issue.

> Also in the future we might share some of the code between
> 1251 and 1271. Any tips for this?

Sorry, no.

There are a couple of examples of multiple maintainers
for wireless drivers in a single directory.

ipw2x00 and rtl818x

ipw2xx has shared files, rtl818x does not.
ipw2xx does not claim a "maintainer" for the
shared files.  That's probably not important.

Maybe the maintainers for ipw2xx might give
some more useful information (cc'd). It turns
out they are the same people though.

As well, the file patterns for rtl818x need
updating.  Thanks for making me check.

cheers, Joe

