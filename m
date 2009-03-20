Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:42149 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZCTUWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 16:22:47 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [RFC][PATCH 4/5] ar9170: USB frontend driver
Date: Fri, 20 Mar 2009 21:22:43 +0100
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
References: <200903170410.20261.chunkeey@web.de> <200903202036.43107.chunkeey@web.de> <200903202058.34420.mb@bu3sch.de>
In-Reply-To: <200903202058.34420.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903202122.44425.chunkeey@web.de> (sfid-20090320_212306_504836_C76ED615)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 20 March 2009 20:58:34 Michael Buesch wrote:
> On Friday 20 March 2009 20:36:42 Christian Lamparter wrote:
> > USB frontend driver code for Atheros AR9170.
> 
> It seems lots of patches didn't make it through the list. :(

which one? I see all of them (v5) in my linux-wireless folder here...
And I don't think that they somehow bypassed the mailinglist & imap filters?!
 
> > +#if 0
> > +#include <linux/mutex.h>
> > +#define mutex_lock(m) do { mutex_lock(m); __acquire(m); } while (0)
> > +#define mutex_unlock(m) do { mutex_unlock(m); __release(m); } while (0)
> > +#endif
> > +
> > +#endif /* __USB_H */
> 
> Whoops, debugging code? :)
hmm, true ;-)... purged 
