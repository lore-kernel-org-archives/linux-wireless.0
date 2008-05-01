Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:39720 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758838AbYEAR0W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2008 13:26:22 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 0/3] Add API for weak DMA masks
Date: Thu, 1 May 2008 19:25:45 +0200
Cc: Christoph Hellwig <hch@infradead.org>,
	John Linville <linville@tuxdriver.com>,
	Andi Kleen <andi@firstfloor.org>,
	David Miller <davem@davemloft.net>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Ingo Molnar <mingo@elte.hu>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <200805011638.15910.mb@bu3sch.de> <200805011916.07340.mb@bu3sch.de> <200805011022.55390.jbarnes@virtuousgeek.org>
In-Reply-To: <200805011022.55390.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805011925.46200.mb@bu3sch.de> (sfid-20080501_192627_184057_1093BEB9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 01 May 2008 19:22:55 Jesse Barnes wrote:
> On Thursday, May 01, 2008 10:16 am Michael Buesch wrote:
> > Ok, will redo the patches with that added and the name changed.
> >
> > > Most drivers just do the fallback themselves, right?
> >
> > Right.
> >
> > > So it makes sense to
> > > just update the current code to fallback, and update drivers wanting
> > > specific mask values to check afterwards.  I hate to inflict that kind of
> > > driver wide update on Michael though... :)
> >
> > Well, that's a lot of work and I'm not sure it's worth it.
> > I could live with having dma_set_mask as an API that fails on bad masks
> > and dma_request_mask as an API above that which retries. I think that's
> > just fine. Drivers can be migrated over time to the new API (or not. That
> > can be the driver maintainer's choice).
> 
> Can you also update the docs with the new call, indicating that it should 
> probably used in all but special cases?

Yeah sure. Forgot that.

-- 
Greetings Michael.
