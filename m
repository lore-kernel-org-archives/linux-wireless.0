Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:46236 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754039AbeGFKhC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 06:37:02 -0400
Date: Fri, 6 Jul 2018 12:36:58 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 00/11] Add mt76x0 driver
Message-ID: <20180706103657.GB2033@redhat.com> (sfid-20180706_123706_192006_7F80364D)
References: <1530771142-4118-1-git-send-email-sgruszka@redhat.com>
 <20180705153216.GE17524@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180705153216.GE17524@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 05, 2018 at 05:32:17PM +0200, Lorenzo Bianconi wrote:
> > My integration efforts can be traced here:
> > https://github.com/sgruszka/wireless-drivers-next/commits/mt76x0-draft
> > 
> 
> I just had a brief review of the code and I compiled the driver since at
> the moment I had no adapter for that chipset.
> As a remainder for future improvements/integration most of the code in 
> dma.c, usb.c (except probe/disconnect functions) and tx.c can use the related
> routines in the mt76-usb layer (we need to fill function pointer for chipset
> related stuff if there are differences with mt76x2u, not looked yet).
> Moreover mcu code can use utility routines in usb-mcu.c
> I have not looked at mt76x2 common code yet.

That's my plan. So far I started to unify common mac/wcid code. If
someone want to work on some area i.e. dma/tx, usb or mcu, please
let me know to do not duplicate work.  

Thanks for review!
Stanislaw
