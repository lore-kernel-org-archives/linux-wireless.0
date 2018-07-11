Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36364 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbeGKIKc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jul 2018 04:10:32 -0400
Received: by mail-wm0-f68.google.com with SMTP id s14-v6so1543647wmc.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jul 2018 01:07:29 -0700 (PDT)
Date: Wed, 11 Jul 2018 10:07:25 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: Sean Wang <sean.wang@mediatek.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v2 00/12] Add mt76x0 driver
Message-ID: <20180711080721.GA3871@localhost.localdomain> (sfid-20180711_100736_562219_A965B5D1)
References: <1530875029-26274-1-git-send-email-sgruszka@redhat.com>
 <1531205430.26214.8.camel@mtkswgap22>
 <20180710095222.GA18926@redhat.com>
 <1531230864.26214.20.camel@mtkswgap22>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1531230864.26214.20.camel@mtkswgap22>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Tue, 2018-07-10 at 11:52 +0200, Stanislaw Gruszka wrote:
> > On Tue, Jul 10, 2018 at 02:50:30PM +0800, Sean Wang wrote:
> > > > For full support mt7610.bin firmware blob is need, hopefully with 
> > > > the permission of Mediatek, the blob will be pushed into linux-firmware
> > > > git tree.
> > > > 
> > > 
> > > Hi, Stanislaw
> > > 
> > > You can feel free to add mt7610.bin firmware blob to linux-firmware with
> > > the license LICENCE.mediatek I added in [1].
> > > 
> > > 
> > > [1]
> > > http://lists.infradead.org/pipermail/linux-mediatek/2018-June/013759.html
> > 
> > Thank you Sean!
> > 
> > I guess there is no problem with similar submission for
> > mt7662u.bin and mt7662u_rom_patch.bin needed for mt76x2u:
> > https://marc.info/?l=linux-wireless&m=153045438821562&w=2
> > 
> 

Thanks Sean,

I will submit mt7662u.bin and mt7662u_rom_patch.bin with LICENCE.mediatek
soon

> Sure, there is no any problem for submitting mt7662u.bin and
> mt7662u_rom_patch.bin if they are added with LICENCE.mediatek.
> 
> Do you or Lorenzo have a plan to add MT7668u support to mt76?
> MT7668 is a newer wifi device than MT7610u or MT7662u.
> 

Cool, I am interested in adding MT7668u support to mt76 driver.
Is the adapter available on the market?

Regards,
Lorenzo

> > Regards
> > Stanislaw
> > 
> > _______________________________________________
> > Linux-mediatek mailing list
> > Linux-mediatek@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-mediatek
> 
> 
