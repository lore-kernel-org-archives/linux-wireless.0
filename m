Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbXKFOX5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 09:23:57 -0500
Subject: Re: [PATCH] move wlan_*_association_work from header to c file
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
In-Reply-To: <200711061351.14673.hs4233@mail.mn-solutions.de>
References: <200710111151.06989.hs4233@mail.mn-solutions.de>
	 <200710261343.51684.hs4233@mail.mn-solutions.de>
	 <20071106011607.GA23747@tuxdriver.com>
	 <200711061351.14673.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 06 Nov 2007 09:20:56 -0500
Message-Id: <1194358856.12229.3.camel@localhost.localdomain> (sfid-20071106_142400_442822_9EA7741A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-11-06 at 13:51 +0100, Holger Schurig wrote:
> > The 2nd patch "libertas: move to uniform lbs_/LBS_ namespace"
> > breaks the compile of if_sdio.c, so I had to drop it.  I
> > dropped "libertas: clean up association debug messages" as
> > well.
> 
> I didn't see an if_sdio.c in my tree when I made the patch.
> 
> And I wont make a third patch. It's quite discouraging to send 
> things which don't get applied (for no known reasons) for more 
> than a week. And during that time they bitrot. Would the patch 
> have been applied timely, it would have worked in the first 
> place.

This is the way things work.  The patch clearly was not material for
2.6.24 given the timing.  Therefore, it's 2.6.25.  Therefore, since
if_sdio.c was ready to go in _August_, it hit 2.6.24, but you didn't
have it because your patch was based on 2.6.23, not 2.6.24-rc1.  That's
distributed development.  If you want a feature, you have to keep coming
back until it gets where you need to go, if you want the benefits of
distributed development.

> Also, changing all things wlan_XXX in libertas_XXX is soooo easy. 
> However, I won't do it. The one who originally asked for the 
> cleanup patch should do the work and have the patience to get 
> the patch through, I have real work to do.

In any case, thanks for the work.  I'll see if I can pick it up.

Dan

