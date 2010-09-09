Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59125 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab0IIOPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 10:15:08 -0400
Date: Thu, 9 Sep 2010 07:10:28 -0700
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Steve deRosier <steve@cozybit.com>, linux-wireless@vger.kernel.org
Subject: Re: libertas_tf
Message-ID: <20100909141023.GA5476@tuxdriver.com>
References: <1282764076.3667.12.camel@jlt3.sipsolutions.net>
 <AANLkTikc0-FbeRHm-0rxrWCGgaxa7svCsQmqpAD-87cq@mail.gmail.com>
 <5144f966da86d4ab0984bc15bdd5fcab@localhost>
 <AANLkTimgvEShOKnA3TTf0_3p2ghP2OL8ngKPBgpkf+zf@mail.gmail.com>
 <d09bb244b842cf15a1513899d19bd39d@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d09bb244b842cf15a1513899d19bd39d@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 07, 2010 at 11:02:45PM +0200, Johannes Berg wrote:
> 
> On Tue, 7 Sep 2010 13:52:47 -0700, Steve deRosier <steve@cozybit.com>
> wrote:

> > I'm now working on getting it all up to head, so patches should be
> > coming soon.  Actually, on that note, how would you prefer I get them
> > to you?  We're talking about an entire new module, libertas_tf_sdio,
> > and lots of patches to the existing libertas_tf modules.  Something
> > like 40+ patches.  Would you prefer a patchset posted, or me to squash
> > a bunch into fewer but larger patches, or would you prefer to pull
> > from my git tree?
> 
> Sounds like a lot of stuff... John will have to answer that. I think
> posting it piecemeal as much as possible would probably be preferable.

Yes, just post the series.  If you can separate it into a few
sub-series that might be nice, but don't sweat that too much.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
