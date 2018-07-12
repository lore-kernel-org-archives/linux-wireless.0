Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:42968 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726575AbeGLLum (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jul 2018 07:50:42 -0400
Date: Thu, 12 Jul 2018 13:41:29 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: Sean Wang <sean.wang@mediatek.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v2 00/12] Add mt76x0 driver
Message-ID: <20180712114129.GB3149@redhat.com> (sfid-20180712_134135_271250_153D2A58)
References: <1530875029-26274-1-git-send-email-sgruszka@redhat.com>
 <1531205430.26214.8.camel@mtkswgap22>
 <20180710095222.GA18926@redhat.com>
 <1531230864.26214.20.camel@mtkswgap22>
 <20180711080721.GA3871@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180711080721.GA3871@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

On Wed, Jul 11, 2018 at 10:07:25AM +0200, Lorenzo Bianconi wrote:
> > On Tue, 2018-07-10 at 11:52 +0200, Stanislaw Gruszka wrote:
> > > On Tue, Jul 10, 2018 at 02:50:30PM +0800, Sean Wang wrote:
> > > > > For full support mt7610.bin firmware blob is need, hopefully with 
> > > > > the permission of Mediatek, the blob will be pushed into linux-firmware
> > > > > git tree.
> > > > > 
> > > > 
> > > > Hi, Stanislaw
> > > > 
> > > > You can feel free to add mt7610.bin firmware blob to linux-firmware with
> > > > the license LICENCE.mediatek I added in [1].
> > > > 
> > > > 
> > > > [1]
> > > > http://lists.infradead.org/pipermail/linux-mediatek/2018-June/013759.html
> > > 
> > > Thank you Sean!
> > > 
> > > I guess there is no problem with similar submission for
> > > mt7662u.bin and mt7662u_rom_patch.bin needed for mt76x2u:
> > > https://marc.info/?l=linux-wireless&m=153045438821562&w=2
> > > 
> > 
> 
> Thanks Sean,
> 
> I will submit mt7662u.bin and mt7662u_rom_patch.bin with LICENCE.mediatek
> soon
> 
> > Sure, there is no any problem for submitting mt7662u.bin and
> > mt7662u_rom_patch.bin if they are added with LICENCE.mediatek.
> > 
> > Do you or Lorenzo have a plan to add MT7668u support to mt76?
> > MT7668 is a newer wifi device than MT7610u or MT7662u.

>From my side I haven't yet planed to support this chip, but I consider
to help working on that after finish work I currently planed to do (i.e.
support for older MT7630E, MT7610E chips).

Ultimate goal would be having you guys @Mediatek supporting your
wifi chips in the mineline, similarly like you do for other
hardware :-) I hope making mt76 more generic by adding new chips
support, hence make easier to do that in the future, will
convince you to support mainline instead of working on your of
the tree driver. Obviously there are pros and cons of that approach
and you might have good reasons not to do that too.
 
> Cool, I am interested in adding MT7668u support to mt76 driver.
> Is the adapter available on the market?

According to https://wikidevi.com/wiki/MediaTek only 4 non-standard
devices were provided with the MT7668u chip so far. I guess is hard for
the chip vendor to say how popular will particular product be by OEMs.

Thanks
Stanislaw
