Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36114 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751761AbeGDOAS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 10:00:18 -0400
Date: Wed, 4 Jul 2018 16:00:13 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Hans Ulli Kroll <ulli.kroll@googlemail.com>
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        lorenzo.bianconi83@gmail.com, Felix Fietkau <nbd@nbd.name>,
        Jakub =?utf-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [ANN] mt76x0 usb driver
Message-ID: <20180704140012.GA26399@redhat.com> (sfid-20180704_160023_968359_7D1824A9)
References: <20180409141032.GA9247@redhat.com>
 <20180409142640.GA5680@localhost.localdomain>
 <20180409144819.GA9253@redhat.com>
 <20180625120816.GA2072@redhat.com>
 <CAA2SeNJjHCrO5NyznK+EJt5K6SRVRr_FPZA2i53Z-FnqzkKz_g@mail.gmail.com>
 <20180625135419.GA3282@redhat.com>
 <CAJ0CqmXE7hF8UAe2iAZ7GhYWb7Uf3zJ+Fg_ervfyK1ojS1Oh=w@mail.gmail.com>
 <alpine.LNX.2.00.1807031725420.3545@T420s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.LNX.2.00.1807031725420.3545@T420s>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Tue, Jul 03, 2018 at 05:31:04PM +0200, Hans Ulli Kroll wrote:
> > On Mon, Jun 25, 2018 at 02:55:51PM +0200, Lorenzo Bianconi wrote:
> 
> > > Not sure why many integration commits in upstream is a problem. I think
> > > having patches posted on mailing list is better than doing them in my
> > > "private" tree without any review.
> > >
> > > > What do you think?
> > >
> > > I was thinking about posting mt76x0 driver in a subdir (there is sill
> > > some cleanup work need to be done there), wait for upstream mt76x2u
> > > integration, then post patches that remove duplication between mt76x2
> > > and mt76x0 and add support for mt76x0e on the way.
> > >
> > 
> > Ack, fine. I modified a little bit mt76x2u/usb architecture moving
> > some parts in common with mt76x0u
> > in mt76-usb module (e.g. mt76_queue management in tx_status data path,
> > tx_stats workqueue,
> > some mcu utility routines). In this way the integration will be easier I guess
> > 
> > Regards,
> > Lorenzo
> > 
> > > Thanks
> > > Stanislaw
> > 
> 
> I'm currrently working mt76x0u on top of Lorenzo's mt76x2u driver.

Hmm, I think efforts should be somehow synchronized here.

I have almost ready for post patches adding mt76x0 driver to the kernel.
Some cleanup work is probably needed, but I think they can be reviewed
and merged. They do not conflict with patches currently posted Lorenzo
except small changes in mt76.h and Makefile files, what can be easy
to resolve.

Thanks
Stanislaw
