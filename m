Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:45887 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbZFRX4N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 19:56:13 -0400
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: linux-wireless@vger.kernel.org
Subject: Re: AR2424 speed issue.
Date: Thu, 18 Jun 2009 17:46:27 -0600
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
References: <200906122006.55492.tfjellstrom@shaw.ca> <1245368044.6830.18.camel@localhost>
In-Reply-To: <1245368044.6830.18.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200906181746.28434.tfjellstrom@shaw.ca>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu June 18 2009, Maxim Levitsky wrote:
> On Fri, 2009-06-12 at 20:06 -0600, Thomas Fjellstrom wrote:
> > I just got a new laptop with an Atheros 2424 based wifi card (lspci says
> > AR242x, but the pci device id is: 0035).
> >
> > While it seems to be stable, it is quite slow for 802.11g. The maximum
> > speed I can get out of the ath5k driver is the speed it auto connects at:
> > 36Mb/s. If I force it to anything higher, nothing can get through (the
> > actual connection seems to stay up till some form of very long time out
> > happens).
> >
> > I just tried the madwifi drivers on madwifi's website (latest trunk
> > snapshot, and svn trunk itself) and It auto connects at 18Mb/s. If I up
> > the rate to 54Mb/s the connection stays up, but it doesn't really seem to
> > be transferring any faster.
> >
> > For comparison's sake I tried it out in Windows 7. It auto connects at
> > 54Mb/s and can stream 1080p h264 without stuttering. In linux however,
> > many SD or lower res Xvid won't play without stuttering. 720p and 1080p
> > are unwatchable.
> >
> > What can be done about this? Is there some setting I'm overlooking? Its
> > quite annoying to have to reboot into windows to watch some videos.
>
> You probably have AR2425. Aspire one?

It is an AR2425, but its a Lenovo "ThinkPad" SL500 (based on the IdeaPad stuff 
it seems :()

> I have tried madwifi too (and unfortunaly found out that this driver
> isn't any better in regard to transfer speeds) and stability.
>
> Bob Copeland, recently, wrote patches that make the card set TX power
> properly, maybe you need to update kernel to take advantage of that?
>
> But here on my aspire one ath5k gives 54M speeds, but very often
> transfers stall, I will attempt soon to figure out what is wrong.

For some reason things seem to have automagically fixed themselves. After a 
little while it started to connect at 54Mb all by itself, and things are 
working.

Initially it didn't want to work right with any driver, but now it does, at 
least with ath5k (not sure if its git or from 2.6.29 tbh, I had git installed 
at one point, but I have absolutely no idea if apt has overwritten it or not 
by now).

> Best regards,
> 	Maxim Levitsky
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
