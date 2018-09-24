Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io1-f43.google.com ([209.85.166.43]:45520 "EHLO
        mail-io1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbeIXUae (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 16:30:34 -0400
Received: by mail-io1-f43.google.com with SMTP id e12-v6so17708479iok.12
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2018 07:28:10 -0700 (PDT)
MIME-Version: 1.0
References: <20180924140701.GA2089@redhat.com> <20180924141311.GI783@localhost.localdomain>
 <20180924141932.GA5031@redhat.com>
In-Reply-To: <20180924141932.GA5031@redhat.com>
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Mon, 24 Sep 2018 16:27:59 +0200
Message-ID: <CAJ0CqmW7KeuvYvyu3h6nY8z9X3Z1OknzW81iM4=gqLDY7XVzyw@mail.gmail.com> (sfid-20180924_162814_403542_B170BBD7)
Subject: Re: mt76x0 random crashes after c12128ce44b0
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Felix Fietkau <nbd@nbd.name>, Zero Chaos <sidhayn@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> hi
>
> On Mon, Sep 24, 2018 at 04:13:11PM +0200, Lorenzo Bianconi wrote:
> > On Sep 24, Stanislaw Gruszka wrote:
> > > Hi, after -next commit:
> > >
> > > commit c12128ce44b04a987c4eb0f733cc99c4dd50d45a
> > > Author: Felix Fietkau <nbd@nbd.name>
> > > Date:   Fri Jul 13 16:26:15 2018 +0200
> > >
> > >     mt76: use a per rx queue page fragment cache
> > >
> > > I have random crashes when load or unlod mt76x0u module.
> > >
> >
> > Hi Stanislaw,
> >
> > could you please try following patch (I am not 100% sure it fixes the issue)
>
> Still crashes when module is unloaded.

ok, what are the steps to reproduce it? rmmod mt76x0?

>
> Regards
> Stanislaw
