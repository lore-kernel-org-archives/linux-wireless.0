Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:39528 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbZJPQEt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 12:04:49 -0400
Date: Fri, 16 Oct 2009 09:01:24 -0700
From: Greg KH <greg@kroah.com>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] staging/stlc45xx: Fix compile error
Message-ID: <20091016160124.GA6415@kroah.com>
References: <1255575825.10636.17.camel@laptop>
 <87zl7rbyl2.fsf@nokia.com>
 <390803460910160711i5f7edcc3ue737c05a8b1495b1@mail.gmail.com>
 <200910161654.29933.chunkeey@googlemail.com>
 <390803460910160859m6364219fx59fe067432a4942e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <390803460910160859m6364219fx59fe067432a4942e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 16, 2009 at 11:59:04AM -0400, Javier Martinez Canillas wrote:
> >> At least I could make it compile when the API changes and work on bugs
> >> reported until you are confident that p54spi driver is good enough and
> >> there is no need anymore for stlc45xx.
> >
> > p54spi IS stlc45xx, but with a different name.
> >
> 
> In that case I guess probably the best option would be to remove
> stlc45xx from staging as Kalle sugested. Users should migrate to
> p54spi since it is already in /net/wireless/

Ah, ok, I'll go delete it.

thanks,

greg k-h
