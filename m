Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:55972 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab3H2EiX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Aug 2013 00:38:23 -0400
Received: by mail-qa0-f43.google.com with SMTP id bv4so948152qab.9
        for <linux-wireless@vger.kernel.org>; Wed, 28 Aug 2013 21:38:22 -0700 (PDT)
From: adam.gradzki@gmail.com
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [BUG] iwlwifi Microcode SW error (firmware version: 18.168.6.1)
Date: Thu, 29 Aug 2013 00:38:20 -0400
Message-ID: <2449090.W0ZgYRKzHN@nuclearreactor> (sfid-20130829_063827_186030_D24FF204)
In-Reply-To: <1377750599.4418.3.camel@porter.coelho.fi>
References: <7144869.jC5clVvrrO@nuclearreactor> <1377750599.4418.3.camel@porter.coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luca,

I was browsing the web while in a large hall with many connected wireless 
clients. There were also several routers sharing a common SSID. I remember 
playing with various RTS and fragmentation thresholds so this may have been 
the trigger. The connection itself involved WPA2 Enterprise PEAP w/ MSCHAPv2 
authentication. I wish I could go into more detail but I was browsing the 
system log long after the fact so I'm having trouble remembering things off the 
top of my head.

Linux laptop 3.10.9-1-ARCH #1 SMP PREEMPT Wed Aug 21 13:49:35 CEST 2013 x86_64 
GNU/Linux

Regards,
Adam


On Thursday, August 29, 2013 07:29:59 AM you wrote:
> Hi Adam,
> 
> On Thu, 2013-08-29 at 00:17 -0400, adam.gradzki@gmail.com wrote:
> > I would like to report a problem with the Intel iwlwifi driver
> > Here is what I found in my system log:
> > 
> > http://pastebin.com/j5cVsqzz
> 
> Thanks for reporting! Could you please give a bit more details on what
> you were doing when this happened? Just a simple connection to an AP?
> Heavy traffic?
> 
> --
> Cheers,
> Luca.

