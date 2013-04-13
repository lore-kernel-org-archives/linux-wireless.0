Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:45074 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab3DMBIM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Apr 2013 21:08:12 -0400
Received: by mail-qa0-f43.google.com with SMTP id i13so74592qae.2
        for <linux-wireless@vger.kernel.org>; Fri, 12 Apr 2013 18:08:10 -0700 (PDT)
Message-ID: <5168AFF8.2090808@lwfinger.net> (sfid-20130413_030816_189759_9641952B)
Date: Fri, 12 Apr 2013 20:08:08 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Patrick Steinhardt <steinhardt.ptk@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: GSoC 2013 - b43 driver
References: <20130411082543.GA346@ArchPC.zedat.fu-berlin.de>
In-Reply-To: <20130411082543.GA346@ArchPC.zedat.fu-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patrick,

I think that your coding experience makes you qualified to undertake the coding 
necessary to improve the performance of b43 on the 14e4:432b device; however, I 
recommend that you not attempt it as a GSoC project. The reason is that those 
projects are highly visible, and what you are trying to do is very difficult. 
The actual coding is likely not a problem, but knowing what to code is not 
trivial. I would hate for you to fail in a way that would be so completely obvious.

As you probably know, b43 has been developed using reverse engineering (RE) 
techniques. We have no knowledge of the internal workings of the chips. Since 
the LP-PHY, more and more has been required by the driver. Earlier PHY models 
did quite a lot in the firmware. With the N PHYs such as your device has, the 
problem got even worse. and the implementation is more incomplete. For instance, 
implementation of power regulation in the wireless chip has barely been touched.

At the moment, I am the only person doing any of the RE work, and I have 
relatively little time to work on that. Much of the more recent development has 
come from comparing MMIO dumps between wl and b43 to see what parts are missing 
from b43. That requires an extremely good knowledge of the existing driver, and 
that would take a long time to acquire.

The b43 project welcomes your interest, and I hope you pursue it eventually, but 
I still think you should find another project for the GSoC.

Larry

