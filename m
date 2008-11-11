Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41208 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbYKLDQJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 22:16:09 -0500
Date: Tue, 11 Nov 2008 18:21:02 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] net/ieee80211 -> drivers/net/ipw2x00/libipw_*
	rename
Message-ID: <20081111232102.GA5827@tuxdriver.com> (sfid-20081112_041614_770371_DA92499B)
References: <1226440265-21240-3-git-send-email-linville@tuxdriver.com> <1226440265-21240-4-git-send-email-linville@tuxdriver.com> <200811112322.33623.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200811112322.33623.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 11, 2008 at 11:22:33PM +0100, Michael Buesch wrote:
> On Tuesday 11 November 2008 22:51:05 John W. Linville wrote:
> > +config LIBIPW
> > +	tristate
> > +	select WIRELESS_EXT
> > +	select CRYPTO
> > +	select CRYPTO_ARC4
> > +	select CRYPTO_ECB
> > +	select CRYPTO_AES
> > +	select CRYPTO_MICHAEL_MIC
> > +	select CRYPTO_ECB
> > +	select CRC32
> > +	select LIB80211
> > +	select LIB80211_CRYPT_WEP
> > +	select LIB80211_CRYPT_TKIP
> > +	select LIB80211_CRYPT_CCMP
> > +	---help---
> > +	This option enables the hardware independent IEEE 802.11
> > +	networking stack.  This component is deprecated in favor of the
> > +	mac80211 component.
> 
> Let's remove this helptext, or replace it by something that's actually true. ;)
> 	---help---
> 	  This option enables common routines for the IPW2100 and IPW2200 drivers.

Yes, good comment.

Thanks,

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
