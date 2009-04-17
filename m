Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f126.google.com ([209.85.221.126]:62700 "EHLO
	mail-qy0-f126.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbZDQTnF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2009 15:43:05 -0400
Received: by qyk32 with SMTP id 32so103836qyk.33
        for <linux-wireless@vger.kernel.org>; Fri, 17 Apr 2009 12:43:02 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18920.56416.860697.279433@gargle.gargle.HOWL> (sfid-20090417_214310_019526_58FE0F99)
Date: Sat, 18 Apr 2009 01:15:36 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iw: Add set/get for frag/rts threshold and retry limits
In-Reply-To: <1239996679.5110.13.camel@johannes.local>
References: <20090417185041.GA17526@jm.kir.nu>
	<18920.55219.833341.713847@gargle.gargle.HOWL>
	<1239996679.5110.13.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sat, 2009-04-18 at 00:55 +0530, Sujith wrote:
> > Jouni Malinen wrote:
> > > --- iw.orig/nl80211.h	2009-04-17 21:48:13.000000000 +0300
> > > +++ iw/nl80211.h	2009-04-17 21:48:17.000000000 +0300
> > > @@ -7,7 +7,7 @@
> > >   * Copyright 2008 Michael Wu <flamingice@sourmilk.net>
> > >   * Copyright 2008 Luis Carlos Cobo <luisca@cozybit.com>
> > >   * Copyright 2008 Michael Buesch <mb@bu3sch.de>
> > > - * Copyright 2008 Luis R. Rodriguez <lrodriguez@atheros.com>
> > > + * Copyright 2008, 2009 Luis R. Rodriguez <lrodriguez@atheros.com>
> > >   * Copyright 2008 Jouni Malinen <jouni.malinen@atheros.com>
> > >   * Copyright 2008 Colin McCabe <colin@cozybit.com>
> > 
> > I don't think Luis would complain, but still... :-)
> 
> He just copied the kernel file in ...
> 

Ah, ok.
Sorry. :)

Sujith
