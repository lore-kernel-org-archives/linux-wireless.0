Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:41968 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751621AbcILPvE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 11:51:04 -0400
Message-ID: <1473695458.6389.3.camel@hadess.net> (sfid-20160912_175107_367711_0237ABEC)
Subject: Re: Support of rtl8723bs
From: Bastien Nocera <hadess@hadess.net>
To: Hanno Zulla <abos@hanno.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: anthony.wong@canonical.com, linux-wireless@vger.kernel.org
Date: Mon, 12 Sep 2016 17:50:58 +0200
In-Reply-To: <cd991918-0bfa-a9a3-15e5-aa8561db2c65@hanno.de>
References: <688574b6-1141-f408-d397-535f1f69999e@hanno.de>
         <1473683031.2930.3.camel@hadess.net> <wrfjtwdli39u.fsf@redhat.com>
         <5b920339-abcd-0fc4-f054-039155c531a0@lwfinger.net>
         <cd991918-0bfa-a9a3-15e5-aa8561db2c65@hanno.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-09-12 at 17:48 +0200, Hanno Zulla wrote:
> Hi,
> 
> > Longer term I think it makes sense to add SDIO support to rtl8xxxu.
> > The
> > differences between the USB version and the SDIO version are rather
> > small.
> 
> 
> This is beyond my expertise, sadly.
> 
> Is there a good blueprint / example of a previous case where a USB
> driver had SDIO support added that one might learn from?

I don't know on top of my head, sorry. Best look in the kernel sources
directly.
