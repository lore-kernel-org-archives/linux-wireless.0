Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f212.google.com ([209.85.220.212]:45619 "EHLO
	mail-fx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbZFRXeM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 19:34:12 -0400
Received: by fxm8 with SMTP id 8so1431882fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 16:34:14 -0700 (PDT)
Subject: Re: AR2424 speed issue.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: tfjellstrom@shaw.ca
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200906122006.55492.tfjellstrom@shaw.ca>
References: <200906122006.55492.tfjellstrom@shaw.ca>
Content-Type: text/plain
Date: Fri, 19 Jun 2009 02:34:04 +0300
Message-Id: <1245368044.6830.18.camel@localhost>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-06-12 at 20:06 -0600, Thomas Fjellstrom wrote:
> I just got a new laptop with an Atheros 2424 based wifi card (lspci says 
> AR242x, but the pci device id is: 0035).
> 
> While it seems to be stable, it is quite slow for 802.11g. The maximum speed I 
> can get out of the ath5k driver is the speed it auto connects at: 36Mb/s. If I 
> force it to anything higher, nothing can get through (the actual connection 
> seems to stay up till some form of very long time out happens).
> 
> I just tried the madwifi drivers on madwifi's website (latest trunk snapshot, 
> and svn trunk itself) and It auto connects at 18Mb/s. If I up the rate to 
> 54Mb/s the connection stays up, but it doesn't really seem to be transferring 
> any faster.
> 
> For comparison's sake I tried it out in Windows 7. It auto connects at 54Mb/s 
> and can stream 1080p h264 without stuttering. In linux however, many SD or 
> lower res Xvid won't play without stuttering. 720p and 1080p are unwatchable.
> 
> What can be done about this? Is there some setting I'm overlooking? Its quite 
> annoying to have to reboot into windows to watch some videos.
> 

You probably have AR2425. Aspire one?

I have tried madwifi too (and unfortunaly found out that this driver
isn't any better in regard to transfer speeds) and stability.

Bob Copeland, recently, wrote patches that make the card set TX power
properly, maybe you need to update kernel to take advantage of that?

But here on my aspire one ath5k gives 54M speeds, but very often
transfers stall, I will attempt soon to figure out what is wrong.

Best regards,
	Maxim Levitsky 



