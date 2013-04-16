Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:65019 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147Ab3DPIRl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 04:17:41 -0400
Received: by mail-bk0-f50.google.com with SMTP id jg1so108002bkc.23
        for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2013 01:17:39 -0700 (PDT)
Date: Tue, 16 Apr 2013 10:19:38 +0200
From: Patrick Steinhardt <steinhardt.ptk@gmail.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: GSoC 2013 - b43 driver
Message-ID: <20130416081938.GA282@ArchPC.zedat.fu-berlin.de> (sfid-20130416_101748_709262_D8203D81)
References: <20130411082543.GA346@ArchPC.zedat.fu-berlin.de>
 <5168AFF8.2090808@lwfinger.net>
 <CACna6rwAK_nTqg=kXb-0PwjD41Cv0VX1=Ey3jTj7ZECA-C7p_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rwAK_nTqg=kXb-0PwjD41Cv0VX1=Ey3jTj7ZECA-C7p_w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

thanks for your insights, I'll stay away from GSoC with that
idea, then.
I'd still be interested in doing some work but got no idea where
to start. Any recommendations for some resources I might
investigate to get going?

Regards,
Patrick

On Mon, Apr 15, 2013 at 12:36:06PM +0200, Rafał Miłecki wrote:
> 2013/4/13 Larry Finger <Larry.Finger@lwfinger.net>:
> > I think that your coding experience makes you qualified to undertake the
> > coding necessary to improve the performance of b43 on the 14e4:432b device;
> > however, I recommend that you not attempt it as a GSoC project. The reason
> > is that those projects are highly visible, and what you are trying to do is
> > very difficult. The actual coding is likely not a problem, but knowing what
> > to code is not trivial. I would hate for you to fail in a way that would be
> > so completely obvious.
> >
> > As you probably know, b43 has been developed using reverse engineering (RE)
> > techniques. We have no knowledge of the internal workings of the chips.
> > Since the LP-PHY, more and more has been required by the driver. Earlier PHY
> > models did quite a lot in the firmware. With the N PHYs such as your device
> > has, the problem got even worse. and the implementation is more incomplete.
> > For instance, implementation of power regulation in the wireless chip has
> > barely been touched.
> >
> > At the moment, I am the only person doing any of the RE work, and I have
> > relatively little time to work on that. Much of the more recent development
> > has come from comparing MMIO dumps between wl and b43 to see what parts are
> > missing from b43. That requires an extremely good knowledge of the existing
> > driver, and that would take a long time to acquire.
> >
> > The b43 project welcomes your interest, and I hope you pursue it eventually,
> > but I still think you should find another project for the GSoC.
> 
> I would love to see extra developer in b43 project, but I have to
> confirm what Larry has said. It's hard task and we're really missing
> specifications for the hardware.
> 
> There are few things that should be easy to add, like 5GHz support
> (most of the code is already there, it just needs enabling & testing)
> or maybe even (some) 802.11n features.
> 
> Further improvements unfortunately are much more complicated or even
> impossible due to lack of documentation.
> 
> You can try doing MMIO tracking and comparing with closed source
> driver, but it's not trivial and doesn't guarantee you'll notice
> important differences (not to mention understanding them).
> 
> -- 
> Rafał
