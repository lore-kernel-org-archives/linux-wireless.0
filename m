Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tayrelbas01.tay.hp.com ([161.114.80.244]:57373 "EHLO
	tayrelbas01.tay.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759410AbXGLQo0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2007 12:44:26 -0400
Date: Thu, 12 Jul 2007 09:43:28 -0700
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2.6] libertas : fix a few wext abuses...
Message-ID: <20070712164328.GB13445@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <20070710213706.GA7929@bougret.hpl.hp.com> <1184188789.28850.4.camel@localhost.localdomain> <20070712004634.GA12148@bougret.hpl.hp.com> <1184210893.18797.16.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1184210893.18797.16.camel@localhost.localdomain>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 11, 2007 at 11:28:12PM -0400, Dan Williams wrote:
> On Wed, 2007-07-11 at 17:46 -0700, Jean Tourrilhes wrote:
> > 
> > 	By the way, from my glancing at the driver, the Libertas
> > driver do select CONFIG_IEEE80211, and then doesn't use it ? It seems
> > to force loading a modules that is not needed.
> 
> It does for ieee80211_escape_essid, actually.

	I missed that one. That does not seem essential.

>  Sucks to have to load in
> the whole module just for that, but it's only 50k

	Only 57k ? The orinoco driver itself is less than that, and
you'll find many other wireless driver way smaller than that ! I can
see that you guys are totally unconcerned about bloat.

> and eventually we'll
> still need to load to lib80211 which should eventually have this sort of
> thing.

	You means this sort of bloat ?

> Dan

	Have fun...

	Jean
