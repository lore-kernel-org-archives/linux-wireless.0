Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55914 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752637AbeF1IqQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Jun 2018 04:46:16 -0400
Date: Thu, 28 Jun 2018 01:46:12 -0700
From: Matthew Wilcox <willy@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the xarray tree with the
 wireless-drivers-next tree
Message-ID: <20180628084612.GB7646@bombadil.infradead.org> (sfid-20180628_104630_739342_73431CE9)
References: <20180628145900.4ca1e648@canb.auug.org.au>
 <1530172269.4988.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1530172269.4988.1.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 28, 2018 at 09:51:09AM +0200, Johannes Berg wrote:
> On Thu, 2018-06-28 at 14:59 +1000, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Today's linux-next merge of the xarray tree got a conflict in:
> > 
> >   lib/Kconfig.debug
> > 
> > between commit:
> > 
> >   0e2dc70e3d0d ("bitfield: add tests")
> > 
> > from the wireless-drivers-next tree and commit:
> > 
> >   d968f529e39f ("xarray: Add XArray load operation")
> > 
> > from the xarray tree.
> 
> Thanks for the heads-up! Not really sure where/how we'll be able to get
> that resolved before it hits Linus, but as the conflict seems rather
> easy (overlapping additions), I guess it's not such a big deal.

I don't care which order the tests are presented in.  I'll happily move the
XArray addition to a different location in the file.
