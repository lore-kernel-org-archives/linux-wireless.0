Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54031 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab1COUpz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 16:45:55 -0400
Date: Tue, 15 Mar 2011 16:41:55 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: Marek Vasut <marek.vasut@gmail.com>,
	Dan Williams <dcbw@redhat.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Andrey Yurovsky <andrey@cozybit.com>,
	Colin McCabe <colin@cozybit.com>
Subject: Re: [PATCH 0/3] libertas_spi fixes
Message-ID: <20110315204155.GE2542@tuxdriver.com>
References: <1295642690-16646-1-git-send-email-anarsoul@gmail.com>
 <201102081352.51062.marek.vasut@gmail.com>
 <201102261144.43721.anarsoul@gmail.com>
 <201103152231.25726.anarsoul@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201103152231.25726.anarsoul@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 15, 2011 at 10:31:25PM +0200, Vasily Khoruzhick wrote:
> On Saturday 26 February 2011 11:44:43 Vasily Khoruzhick wrote:
> > On Tuesday 08 February 2011 14:52:50 Marek Vasut wrote:
> > > > Nope, it can't, I tried to do so and it hangs on resume (console cursor
> > > > flickers, so it's not complete hang, but it does not return control to
> > > > shell). Can investigate why if you want.
> > > 
> > > Please do. It's not that I want to block this, but the code seems quick
> > > enough.
> > > 
> > > Btw. Dan, sorry for not looking into this as I promised, but as I can
> > > see, it isn't needed anymore. Open Source is so awesome at this :-)
> > 
> > Hi,
> > 
> > and sorry for a long delay.
> > 
> > It fails on firmware request, looks like pxa2xx-mci driver is not ready
> > yet. It works OK without workqueue if I compile firmware into kernel (but
> > it's not a way to go, right?)
> 
> Ping :) should I resend 3rd patch?

It would seem so...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
