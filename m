Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32923 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932492Ab1DNTNc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 15:13:32 -0400
Received: by fxm17 with SMTP id 17so1385474fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 12:13:31 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [RFT] p54: implement multicast + arp req PS filter
Date: Thu, 14 Apr 2011 21:13:27 +0200
Cc: linux-wireless@vger.kernel.org
References: <201104020058.17232.chunkeey@googlemail.com> <201104100441.37852.jcmvbkbc@gmail.com> <201104140148.56798.jcmvbkbc@gmail.com>
In-Reply-To: <201104140148.56798.jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104142113.27392.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 13 April 2011 23:48:54 Max Filippov wrote:
> Hello, Christian.
> 
> > > > "sagred stuff" ?
> > > yeah, it was a while ago... 
> > > "p54spi (STLC4560) with Marvel XScale CPU (kernel 2.6.25.4)"
> > > http://www.spinics.net/lists/linux-wireless/msg55967.html
> > > 
> > > AFAIK they have another p54spi firmware
> > > "phy0: FW rev 2.19.0.0.A.14 Private - Softmac protocol 5.6"
> > 
> > Ok, I'll try to test it with firmware images other than nokia's native.
> 
> The results are the following:
> 
> 2.19.0.0.A.14 -- ARP and multicast filters are completely ignored in both normal mode and PSM.
> 2.13.12.0.a.5.2 -- ARP and multicast filters are completely ignored in both normal mode and PSM.
> 2.13.0.0.a.23 -- ARP and multicast filters are completely ignored in both normal mode and PSM.
> 2.13.0.0.a.22.0 -- same as with nokia's native
> 2.13.0.0.a.13.14 -- ARP and multicast filters are completely ignored in both normal mode and PSM.

thanks,

so the sagrad firmwares do work on the n8xx? Maybe it would be a good idea
to send them over to maxi@daemonizer.de. Do you still have the binaries?

Regards,
	Chr
