Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:37205 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932463AbeGCPfj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jul 2018 11:35:39 -0400
Received: by mail-wm0-f66.google.com with SMTP id n17-v6so2790057wmh.2
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jul 2018 08:35:38 -0700 (PDT)
Date: Tue, 3 Jul 2018 17:31:04 +0200 (CEST)
From: Hans Ulli Kroll <ulli.kroll@googlemail.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        lorenzo.bianconi83@gmail.com, Felix Fietkau <nbd@nbd.name>,
        =?ISO-8859-2?Q?Jakub_Kici=F1ski?= <moorray3@wp.pl>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [ANN] mt76x0 usb driver
In-Reply-To: <CAJ0CqmXE7hF8UAe2iAZ7GhYWb7Uf3zJ+Fg_ervfyK1ojS1Oh=w@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1807031725420.3545@T420s> (sfid-20180703_173605_273337_1DC78754)
References: <20180409141032.GA9247@redhat.com> <20180409142640.GA5680@localhost.localdomain> <20180409144819.GA9253@redhat.com> <20180625120816.GA2072@redhat.com> <CAA2SeNJjHCrO5NyznK+EJt5K6SRVRr_FPZA2i53Z-FnqzkKz_g@mail.gmail.com> <20180625135419.GA3282@redhat.com>
 <CAJ0CqmXE7hF8UAe2iAZ7GhYWb7Uf3zJ+Fg_ervfyK1ojS1Oh=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

>
> On Mon, Jun 25, 2018 at 02:55:51PM +0200, Lorenzo Bianconi wrote:

> > Not sure why many integration commits in upstream is a problem. I think
> > having patches posted on mailing list is better than doing them in my
> > "private" tree without any review.
> >
> > > What do you think?
> >
> > I was thinking about posting mt76x0 driver in a subdir (there is sill
> > some cleanup work need to be done there), wait for upstream mt76x2u
> > integration, then post patches that remove duplication between mt76x2
> > and mt76x0 and add support for mt76x0e on the way.
> >
> 
> Ack, fine. I modified a little bit mt76x2u/usb architecture moving
> some parts in common with mt76x0u
> in mt76-usb module (e.g. mt76_queue management in tx_status data path,
> tx_stats workqueue,
> some mcu utility routines). In this way the integration will be easier I guess
> 
> Regards,
> Lorenzo
> 
> > Thanks
> > Stanislaw
> 

I'm currrently working mt76x0u on top of Lorenzo's mt76x2u driver.

Ulli
