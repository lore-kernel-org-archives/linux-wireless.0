Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37320 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387566AbeHAJ6V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Aug 2018 05:58:21 -0400
Received: by mail-wr1-f67.google.com with SMTP id u12-v6so838025wrr.4
        for <linux-wireless@vger.kernel.org>; Wed, 01 Aug 2018 01:13:51 -0700 (PDT)
Date: Wed, 1 Aug 2018 10:13:47 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v3 00/14] Add mt76x0 driver
Message-ID: <20180801081346.GA4794@localhost.localdomain> (sfid-20180801_102122_902025_2FB55E8C)
References: <1533040864-9026-1-git-send-email-sgruszka@redhat.com>
 <87y3dqzga9.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87y3dqzga9.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Aug 01, Kalle Valo wrote:
> Stanislaw Gruszka <sgruszka@redhat.com> writes:
> 
> > Add mt76x0 driver for MT7610U based USB dongles. Currently driver
> > support only STA mode.
> >
> > mt76x0 is based on Jakub's mt7601u driver already included
> > in the kernel. I would like the driver be integrated as part
> > of mt76 (instead of separate driver in mediatek dir like mt7601u)
> > to utilize mt76 code for adding support for MT76x0 PCIe devices
> > in further development.
> 
> So what's the future for mt7601u, are we going to delete it? What's
> Jakub's opinion about all this? And what's the delta featurewise between
> mt7601u and this driver? Which one will be loaded by default?

I think we can integrate mt7601u in mt76 as soon as mt76x0 is merged since the
code path is pretty similar. Jakub what do you think? (That was actually on my
ToDo list :))
For the moment I guess both drivers can coexist since the usb_device_id lists
seem different

Regards,
Lorenzo

> 
> Also I noticed that mt76 is missing an entry in MAINTAINERS file? Could
> someone send a separate patch to add that, please?
> 
> -- 
> Kalle Valo
