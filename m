Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f50.google.com ([209.85.213.50]:56364 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab3H2Qgz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Aug 2013 12:36:55 -0400
Received: by mail-yh0-f50.google.com with SMTP id f10so162900yha.23
        for <linux-wireless@vger.kernel.org>; Thu, 29 Aug 2013 09:36:54 -0700 (PDT)
From: adam.gradzki@gmail.com
To: Luciano Coelho <luciano.coelho@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [BUG] iwlwifi Microcode SW error (firmware version: 18.168.6.1)
Date: Thu, 29 Aug 2013 12:35:30 -0400
Message-ID: <11203548.8TH3DJmvk0@nuclearreactor> (sfid-20130829_183658_848866_FE146E2E)
In-Reply-To: <1377751965.4418.4.camel@porter.coelho.fi>
References: <7144869.jC5clVvrrO@nuclearreactor> <2449090.W0ZgYRKzHN@nuclearreactor> <1377751965.4418.4.camel@porter.coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luca,

I have been having wireless connectivity problems indoors on campus with this 
Intel card since I bought this laptop in September 2012. Quite often the 
wireless is completely unusable.

I can reliably reproduce this problem whenever I attempt to connect to the 
University of Pittsburgh network in several locations indoors around campus. 
The problem is very prominent when I am around APs with 6+ clients around me.

I have attached a link to my complete system log dump over 3 reboot cycles 
today.

I can connect sporadically and send a few bytes here and there before the 
wireless becomes completely unusable

I have tried connecting in Windows 8 x64 and I also experience the same 
issues, except that my network adapter goes into "Limited connectivity" mode 
and gives me a 169.x.x.x address with no IPv4 gateway.

Here is the link to my logs:
http://paste.ubuntu.com/6040891/

~ Adam

On Thursday, August 29, 2013 07:52:45 AM Luciano Coelho wrote:
> On Thu, 2013-08-29 at 00:38 -0400, adam.gradzki@gmail.com wrote:
> > Hi Luca,
> > 
> > I was browsing the web while in a large hall with many connected wireless
> > clients. There were also several routers sharing a common SSID. I remember
> > playing with various RTS and fragmentation thresholds so this may have
> > been
> > the trigger. The connection itself involved WPA2 Enterprise PEAP w/
> > MSCHAPv2 authentication. I wish I could go into more detail but I was
> > browsing the system log long after the fact so I'm having trouble
> > remembering things off the top of my head.
> > 
> > Linux laptop 3.10.9-1-ARCH #1 SMP PREEMPT Wed Aug 21 13:49:35 CEST 2013
> > x86_64 GNU/Linux
> 
> Thanks again! I'll follow this up internally.
> 
> --
> Cheers,
> Luca.

