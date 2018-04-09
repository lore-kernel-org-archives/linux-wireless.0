Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:37936 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751716AbeDIOxx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Apr 2018 10:53:53 -0400
Received: by mail-pf0-f196.google.com with SMTP id y69so5878841pfb.5
        for <linux-wireless@vger.kernel.org>; Mon, 09 Apr 2018 07:53:53 -0700 (PDT)
Date: Mon, 9 Apr 2018 16:53:44 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Jakub =?utf-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [ANN] mt76x0 usb driver
Message-ID: <20180409145342.GB5680@localhost.localdomain> (sfid-20180409_165358_118761_5BCC4F89)
References: <20180409141032.GA9247@redhat.com>
 <20180409142640.GA5680@localhost.localdomain>
 <20180409144819.GA9253@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180409144819.GA9253@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Apr 09, Stanislaw Gruszka wrote:
> On Mon, Apr 09, 2018 at 04:26:42PM +0200, Lorenzo Bianconi wrote:
> > > I would like to integrate the driver to kernel via mt76 driver, i.e.
> > > add USB hooks and mt76x0 mac/phy code to mt76. This will open
> > > possibility to develop support for mt76x2 USB devices as well as mt76x0
> > > PCIe devices in mt76.
> > > 
> > 
> > I have already started supporting mt76x2 USB devices in mt76 since register map
> > is pretty similar to PCIe devices:
> > https://github.com/LorenzoBianconi/wireless-drivers-next/tree/mt76x2u
> > I added some usb utility routines so I think we can integrate mt76x0 in mt76 as
> > well
> 
> Great, I'll start to integrate mt76x0 on top of your tree.

Cool :) actually this branch is in under development but what is really
changing day by day is mt7612u part not usb one so I guess we can use it as
common ground for mt76x2u and mt76x0.
Maybe even the mcu code is in common with mt76x2, isn't it?

Regards,
Lorenzo

> 
> Thanks
> Stanislaw
