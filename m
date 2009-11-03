Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:56375 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466AbZKCHQ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 02:16:28 -0500
Subject: Re: Please consider reverting
 7d930bc33653d5592dc386a76a38f39c2e962344
From: Marcel Holtmann <marcel@holtmann.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
	johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20091103065238.GE3212@core.coreip.homeip.net>
References: <20091103053156.GA3212@core.coreip.homeip.net>
	 <20091102.224957.32364226.davem@davemloft.net>
	 <20091103065238.GE3212@core.coreip.homeip.net>
Content-Type: text/plain
Date: Tue, 03 Nov 2009 16:16:27 +0900
Message-Id: <1257232587.3420.55.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dmitry,

> > > It looks like
> > > 
> > > commit 7d930bc33653d5592dc386a76a38f39c2e962344
> > > Author: Johannes Berg <johannes@sipsolutions.net>
> > > Date:   Tue Oct 20 15:08:53 2009 +0900
> >  ...
> > > is causing oops on resume:
> > 
> > There is a fix for this in my tree and I'll push it to Linus
> > tonight.
> 
> Ah, even better ;) Thanks David.

and can we please stop jumping the gun here and going past the subsystem
maintainers. I think this happens a little bit too much lately.

Regards

Marcel


