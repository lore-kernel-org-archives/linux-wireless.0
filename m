Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50618 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828AbZIARAZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 13:00:25 -0400
Date: Tue, 1 Sep 2009 12:58:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/7] wireless: update WIRELESS_EXT kconfig entry
Message-ID: <20090901165804.GF7650@tuxdriver.com>
References: <1251818566-9264-1-git-send-email-lrodriguez@atheros.com> <1251818566-9264-6-git-send-email-lrodriguez@atheros.com> <4A9D436E.20509@lwfinger.net> <1251820483.24846.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1251820483.24846.0.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 01, 2009 at 05:54:43PM +0200, Johannes Berg wrote:
> On Tue, 2009-09-01 at 10:53 -0500, Larry Finger wrote:
> 
> > > @@ -98,8 +98,16 @@ config WIRELESS_EXT
> > >  	bool "Wireless extensions"
> > >  	default y
> > >  	---help---
> > > -	  This option enables the legacy wireless extensions
> > > -	  (wireless network interface configuration via ioctls.)
> > > +	  This option enables the legacy wireless extensions.
> > > +	  Wireless extensions was the first 802.11 wireless configuration
> > > +	  API used by the networking subsystem. You will not need this unless
> > > +	  you have old userspace utilities or old wireless devices which
> > > +	  have not yet been ported to cfg80211.
> > 
> > I would like this to read "You will need this if you have old
> > userspace utilities or old wireless devices that have not yet been
> > ported to cfg80211."
> 
> Don't those "select WIRELESS_EXT" anyway so you don't have a choice?

Old userland won't do that.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
