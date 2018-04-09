Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:34581 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751728AbeDISzu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Apr 2018 14:55:50 -0400
Received: by mail-wm0-f41.google.com with SMTP id w2so18820135wmw.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Apr 2018 11:55:49 -0700 (PDT)
Date: Mon, 9 Apr 2018 20:52:05 +0200 (CEST)
From: Hans Ulli Kroll <ulli.kroll@googlemail.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        =?ISO-8859-2?Q?Jakub_Kici=F1ski?= <moorray3@wp.pl>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [ANN] mt76x0 usb driver
In-Reply-To: <20180409145342.GB5680@localhost.localdomain>
Message-ID: <alpine.LNX.2.00.1804092045270.8369@T420s> (sfid-20180409_205554_049970_30F921DF)
References: <20180409141032.GA9247@redhat.com> <20180409142640.GA5680@localhost.localdomain> <20180409144819.GA9253@redhat.com> <20180409145342.GB5680@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Mon, 9 Apr 2018, Lorenzo Bianconi wrote:

> On Apr 09, Stanislaw Gruszka wrote:
> > On Mon, Apr 09, 2018 at 04:26:42PM +0200, Lorenzo Bianconi wrote:
> > > > I would like to integrate the driver to kernel via mt76 driver, i.e.
> > > > add USB hooks and mt76x0 mac/phy code to mt76. This will open
> > > > possibility to develop support for mt76x2 USB devices as well as mt76x0
> > > > PCIe devices in mt76.
> > > > 
> > > 
> > > I have already started supporting mt76x2 USB devices in mt76 since register map
> > > is pretty similar to PCIe devices:
> > > https://github.com/LorenzoBianconi/wireless-drivers-next/tree/mt76x2u
> > > I added some usb utility routines so I think we can integrate mt76x0 in mt76 as
> > > well
> > 
> > Great, I'll start to integrate mt76x0 on top of your tree.
> 
> Cool :) actually this branch is in under development but what is really
> changing day by day is mt7612u part not usb one so I guess we can use it as
> common ground for mt76x2u and mt76x0.
> Maybe even the mcu code is in common with mt76x2, isn't it?
> 

from my POV for "general" commands the MCU on mt76x0 and mt76x2 (doesn't 
matter if USB or PCIe) are almost the same i.e. CMD_FUN_SET_OP

The only difference is CMD_CALIBRATION_OP, they are for mt76x0 and mt76x2 
different calibrate id's.

How about the LED on mt76x2 ?

Greetings
Hans
