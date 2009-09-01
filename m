Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:11375 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492AbZIAPqb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 11:46:31 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2009 08:46:34 -0700
Date: Tue, 1 Sep 2009 08:46:33 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/7] wireless: update wireless kconfig description
Message-ID: <20090901154633.GB8261@mosca>
References: <1251818566-9264-1-git-send-email-lrodriguez@atheros.com>
 <1251818566-9264-3-git-send-email-lrodriguez@atheros.com>
 <1251819096.22442.17.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1251819096.22442.17.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 01, 2009 at 08:31:36AM -0700, Johannes Berg wrote:
> On Tue, 2009-09-01 at 08:22 -0700, Luis R. Rodriguez wrote:
> > "Wireless" is a misnomer 802.11 as there are plently
> > of other wireless technologies. Be more specific and refer
> > people to our good hearty wireless wiki for documentation.
> > 
> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> > ---
> >  net/Kconfig |    8 +++++++-
> >  1 files changed, 7 insertions(+), 1 deletions(-)
> > 
> > diff --git a/net/Kconfig b/net/Kconfig
> > index 041c35e..31c208d 100644
> > --- a/net/Kconfig
> > +++ b/net/Kconfig
> > @@ -260,9 +260,15 @@ config FIB_RULES
> >  	bool
> >  
> >  menuconfig WIRELESS
> > -	bool "Wireless"
> > +	bool "IEEE 802.11 - Wireless LAN"
> 
> But this also has WEXT under it which supports pre-802.11 technologies,
> no? 

Heh yeah, good point.

> Might not matter at this point though.

Probably not, its more 802.11 than pre now.

  Luis
