Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:45104 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751879AbeF1I4z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Jun 2018 04:56:55 -0400
Message-ID: <1530176199.4988.2.camel@sipsolutions.net> (sfid-20180628_105717_755602_760CC67B)
Subject: Re: linux-next: manual merge of the xarray tree with the
 wireless-drivers-next tree
From: Johannes Berg <johannes@sipsolutions.net>
To: Matthew Wilcox <willy@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 28 Jun 2018 10:56:39 +0200
In-Reply-To: <20180628084612.GB7646@bombadil.infradead.org>
References: <20180628145900.4ca1e648@canb.auug.org.au>
         <1530172269.4988.1.camel@sipsolutions.net>
         <20180628084612.GB7646@bombadil.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-06-28 at 01:46 -0700, Matthew Wilcox wrote:
> On Thu, Jun 28, 2018 at 09:51:09AM +0200, Johannes Berg wrote:
> > On Thu, 2018-06-28 at 14:59 +1000, Stephen Rothwell wrote:
> > > Hi all,
> > > 
> > > Today's linux-next merge of the xarray tree got a conflict in:
> > > 
> > >   lib/Kconfig.debug
> > > 
> > > between commit:
> > > 
> > >   0e2dc70e3d0d ("bitfield: add tests")
> > > 
> > > from the wireless-drivers-next tree and commit:
> > > 
> > >   d968f529e39f ("xarray: Add XArray load operation")
> > > 
> > > from the xarray tree.
> > 
> > Thanks for the heads-up! Not really sure where/how we'll be able to get
> > that resolved before it hits Linus, but as the conflict seems rather
> > easy (overlapping additions), I guess it's not such a big deal.
> 
> I don't care which order the tests are presented in.  I'll happily move the
> XArray addition to a different location in the file.

Good point, that works.

Thanks!

johannes
