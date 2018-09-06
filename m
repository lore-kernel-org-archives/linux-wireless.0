Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io1-f54.google.com ([209.85.166.54]:39360 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbeIGDPC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 23:15:02 -0400
Received: by mail-io1-f54.google.com with SMTP id l7-v6so131426iok.6
        for <linux-wireless@vger.kernel.org>; Thu, 06 Sep 2018 15:37:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAM0KTbBJuhuEyuZB_z_BcDSeXa-CJ+NwupssS2jLx0pJ0KXQGQ@mail.gmail.com>
 <CAJ0CqmWAqdB8Og7fabLDeZnzFO5Aw5Qd0cYGaLrs7Ls-zM_yQw@mail.gmail.com>
 <CAM0KTbAbjDYNOzivxMdLmYrV9QHgwkLp7zXpdCvn1Kf1uEcQTQ@mail.gmail.com>
 <20180906093213.GB16539@redhat.com> <CAM0KTbAPh5J+cguhE0Qh9c8n_UVK9UyqsHtWUydrXzLTz9sXgQ@mail.gmail.com>
 <CAJ0CqmU0TBc42k=RX3T1DJd2dfGFHu4WuhbATYoe-7poUk3Ekw@mail.gmail.com>
In-Reply-To: <CAJ0CqmU0TBc42k=RX3T1DJd2dfGFHu4WuhbATYoe-7poUk3Ekw@mail.gmail.com>
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Fri, 7 Sep 2018 00:37:11 +0200
Message-ID: <CAJ0CqmUP7TJph=JK1hXvRmK-_7_aDBPJF=RVkS2WC8FqmMyzcQ@mail.gmail.com> (sfid-20180907_003725_732129_9C7AA9D0)
Subject: Re: mt76x0 bug report
To: Zero Chaos <sidhayn@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> > On Thu, Sep 6, 2018 at 5:32 AM Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > >
> > > On Wed, Sep 05, 2018 at 08:52:18PM +0000, Sid Hayn wrote:
> > > > On Tue, Sep 4, 2018 at 5:11 PM Lorenzo Bianconi
> > > > <lorenzo.bianconi@redhat.com> wrote:
> > > > >
> > > > > >
> > > > > > I have one mt76x2u (Alfa AWUS036ACM) and a few mt76x0.
> > > > > >
> > > > > > I've noticed two additional issues in my testing.
> > > > > >
> > > > > > First issue, is that it appears the mt76x0 devices don't work properly
> > > > > > in monitor mode.  Sometimes they seem to monitor one channel properly,
> > > > > > but nothing else.  The mt76x2u works great, channel control, lots of
> > > > > > packets, etc.
> > > > >
> > > > > Could you elaborate a little bit please? how can you reproduce the issue?
> > > > > just add an interface in monitor mode and run a scan?
> > > >
> > > > Correct, standard stuff, use iw to create a monitor mode interface,
> > > > use iw to remove managed mode interface, run some tool such as kismet
> > > > or airodump-ng or even wireshark.
> > >

I think I understood the monitor mode issue with mt76x0 driver. I will
send you a patch tomorrow for testing
Regards,

Lorenzo
