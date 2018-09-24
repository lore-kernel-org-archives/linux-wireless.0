Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57542 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728838AbeIXUfo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 16:35:44 -0400
Date: Mon, 24 Sep 2018 16:33:16 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: Felix Fietkau <nbd@nbd.name>, Zero Chaos <sidhayn@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: mt76x0 random crashes after c12128ce44b0
Message-ID: <20180924143315.GA2039@redhat.com> (sfid-20180924_163321_440531_5806609C)
References: <20180924140701.GA2089@redhat.com>
 <20180924141311.GI783@localhost.localdomain>
 <20180924141932.GA5031@redhat.com>
 <CAJ0CqmW7KeuvYvyu3h6nY8z9X3Z1OknzW81iM4=gqLDY7XVzyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ0CqmW7KeuvYvyu3h6nY8z9X3Z1OknzW81iM4=gqLDY7XVzyw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 24, 2018 at 04:27:59PM +0200, Lorenzo Bianconi wrote:
> >
> > hi
> >
> > On Mon, Sep 24, 2018 at 04:13:11PM +0200, Lorenzo Bianconi wrote:
> > > On Sep 24, Stanislaw Gruszka wrote:
> > > > Hi, after -next commit:
> > > >
> > > > commit c12128ce44b04a987c4eb0f733cc99c4dd50d45a
> > > > Author: Felix Fietkau <nbd@nbd.name>
> > > > Date:   Fri Jul 13 16:26:15 2018 +0200
> > > >
> > > >     mt76: use a per rx queue page fragment cache
> > > >
> > > > I have random crashes when load or unlod mt76x0u module.
> > > >
> > >
> > > Hi Stanislaw,
> > >
> > > could you please try following patch (I am not 100% sure it fixes the issue)
> >
> > Still crashes when module is unloaded.
> 
> ok, what are the steps to reproduce it? rmmod mt76x0?

modprobe -r mt76x0u

Not sure if that matter, but modprobe unload also other mt76 modules.

But also sometimes crashes after first modprobe or when unplug/plug
device .

Thanks
Stanislaw
