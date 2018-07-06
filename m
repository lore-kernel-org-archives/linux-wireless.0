Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35219 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753528AbeGFLhV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 07:37:21 -0400
Received: by mail-wm0-f67.google.com with SMTP id v3-v6so10582492wmh.0
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jul 2018 04:37:20 -0700 (PDT)
Date: Fri, 6 Jul 2018 13:37:17 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 00/11] Add mt76x0 driver
Message-ID: <20180706113716.GA2410@localhost.localdomain> (sfid-20180706_133725_284138_6229A736)
References: <1530771142-4118-1-git-send-email-sgruszka@redhat.com>
 <20180705153216.GE17524@localhost.localdomain>
 <20180706103657.GB2033@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180706103657.GB2033@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jul 06, Stanislaw Gruszka wrote:
> On Thu, Jul 05, 2018 at 05:32:17PM +0200, Lorenzo Bianconi wrote:
> > > My integration efforts can be traced here:
> > > https://github.com/sgruszka/wireless-drivers-next/commits/mt76x0-draft
> > > 
> > 
> > I just had a brief review of the code and I compiled the driver since at
> > the moment I had no adapter for that chipset.
> > As a remainder for future improvements/integration most of the code in 
> > dma.c, usb.c (except probe/disconnect functions) and tx.c can use the related
> > routines in the mt76-usb layer (we need to fill function pointer for chipset
> > related stuff if there are differences with mt76x2u, not looked yet).
> > Moreover mcu code can use utility routines in usb-mcu.c
> > I have not looked at mt76x2 common code yet.
> 
> That's my plan. So far I started to unify common mac/wcid code. If
> someone want to work on some area i.e. dma/tx, usb or mcu, please
> let me know to do not duplicate work.  

I can work on dma/tx/usb stuff since I did it for mt76x2u.
I have just a mt7601u adapter for the moment but I guess
I can use it that tasks.

Regards,
Lorenzo

> 
> Thanks for review!
> Stanislaw
