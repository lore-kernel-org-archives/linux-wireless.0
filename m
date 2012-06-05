Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35138 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab2FENlZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 09:41:25 -0400
Message-ID: <1338903681.4514.43.camel@jlt3.sipsolutions.net> (sfid-20120605_154128_368514_1FDD6AAE)
Subject: Re: [PATCH] wireless: add my new trees to MAINTAINERS
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 05 Jun 2012 15:41:21 +0200
In-Reply-To: <1338903211.3277.1.camel@joe2Laptop> (sfid-20120605_153337_923396_06051E52)
References: <1338898901.4514.40.camel@jlt3.sipsolutions.net>
	 <1338903211.3277.1.camel@joe2Laptop> (sfid-20120605_153337_923396_06051E52)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-05 at 06:33 -0700, Joe Perches wrote:
> On Tue, 2012-06-05 at 14:21 +0200, Johannes Berg wrote:
> > Add my new trees to the MAINTAINERS file
> []
> > diff --git a/MAINTAINERS b/MAINTAINERS
> []
> > @@ -5694,6 +5699,10 @@ F:	include/linux/remoteproc.h
> >  
> >  RFKILL
> >  M:	Johannes Berg <johannes@sipsolutions.net>
> > +W:	http://wireless.kernel.org/
> > +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
> > +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
> > +S:	Maintained
> >  L:	linux-wireless@vger.kernel.org
> >  S:	Maintained
> >  F:	Documentation/rfkill.txt
> 
> no need for multiple S: lines

Oops, copy/paste error, thanks.

johannes

