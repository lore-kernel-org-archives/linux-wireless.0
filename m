Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zoot.epublica.de ([78.46.103.157]:45212 "EHLO zoot.epublica.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751882AbcIMHsA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 03:48:00 -0400
Subject: Re: Support of rtl8723bs
To: Jes Sorensen <Jes.Sorensen@redhat.com>,
        Bastien Nocera <hadess@hadess.net>
References: <688574b6-1141-f408-d397-535f1f69999e@hanno.de>
 <1473683031.2930.3.camel@hadess.net> <wrfjtwdli39u.fsf@redhat.com>
 <5b920339-abcd-0fc4-f054-039155c531a0@lwfinger.net>
 <cd991918-0bfa-a9a3-15e5-aa8561db2c65@hanno.de>
 <1473695458.6389.3.camel@hadess.net> <wrfj4m5lhzja.fsf@redhat.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        anthony.wong@canonical.com, linux-wireless@vger.kernel.org
From: Hanno Zulla <abos@hanno.de>
Message-ID: <4efa3f1a-a91c-7b19-43e3-508cbbd4676e@hanno.de> (sfid-20160913_094804_428670_136BF98C)
Date: Tue, 13 Sep 2016 09:47:55 +0200
MIME-Version: 1.0
In-Reply-To: <wrfj4m5lhzja.fsf@redhat.com>
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> The issues I am aware of is to start out changing the register access
> macros into function pointers and stick them all into the fileops
> structure. Provide a set of SDIO ones to match the USB ones. Then you
> will need some code to detect the device, as that part will obviously be
> different from the USB device detection.
> 
> I know there are a few issues to look out for in the hw register init
> files to look out for too, that does some special casing for SDIO, but
> that should be limited. I am happy to point someone in the right
> direction on that when they get to that.

I had a brief look into the sources of other drivers implementing SDIO,
but not being a kernel-dev, this is out of my league.

If you decide to reprioritize your TODO-List in favour of adding SDIO
sooner, I'll be gladly testing this for you on my hardware (and buy you
a beer).

Kind regards,

Hanno
