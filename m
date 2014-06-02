Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55206 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137AbaFBLDG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2014 07:03:06 -0400
Message-ID: <1401706971.4303.3.camel@jlt4.sipsolutions.net> (sfid-20140602_130310_426203_A1B42A38)
Subject: Re: [PATCH] mac80211: remove PID rate control
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefano Brivio <stefano.brivio@gmx.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Mattias Nissler <mattias.nissler@gmx.de>
Date: Mon, 02 Jun 2014 13:02:51 +0200
In-Reply-To: <20140530234122.5f5e0650@vaiolo.localdomain> (sfid-20140530_234139_432994_F8672B9E)
References: <1401461248-29427-1-git-send-email-linville@tuxdriver.com>
	 <20140530234122.5f5e0650@vaiolo.localdomain>
	 (sfid-20140530_234139_432994_F8672B9E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-05-30 at 23:41 +0200, Stefano Brivio wrote:
> Hi,
> 
> On Fri, 30 May 2014 10:47:28 -0400
> "John W. Linville" <linville@tuxdriver.com> wrote:
> 
> > Minstrel has long since proven its worth.
> 
> Just a quick note: a while ago, somebody proposed
> (http://lkml.iu.edu/hypermail/linux/kernel/1202.3/02307.html) a
> enhanced version of this algorithm that would, according to the related
> research and paper [1], outperform Minstrel in most cases. The patch
> was not accepted as comments (mostly related to coding style, but not
> only that) weren't addressed by the sender. I then never had the time
> to seriously look into it. My understanding is that the amended
> algorithm would spare some air time compared to Minstrel, and thus it
> could provide marginally better performance.
> 
> So, maybe somebody is interested in looking into that. Otherwise, yes,
> let's drop it.

They can add it back if needed - looks like this was some academic paper
and they weren't really interested in submitting it to mainline
properly.

johannes

