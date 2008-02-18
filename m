Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:58815 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbYBRTHw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2008 14:07:52 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [BUG?] b43: Wireless signal lowers when increasing sound
Date: Mon, 18 Feb 2008 20:07:19 +0100
Cc: Ronald <ronald645@gmail.com>, linux-wireless@vger.kernel.org
References: <47B93277.5030304@gmail.com> <20080218153511.GB3098@tuxdriver.com>
In-Reply-To: <20080218153511.GB3098@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802182007.19859.mb@bu3sch.de> (sfid-20080218_190756_995241_8E4B3BB1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 18 February 2008 16:35:11 John W. Linville wrote:
> On Mon, Feb 18, 2008 at 08:23:35AM +0100, Ronald wrote:
> > hey,
> >
> > I'm currently using the b43 driver for my BCM4311 chipset. The driver works 
> > extremely well. It is the only option under Linux that supports WPA-AES 
> > with wpa_supplicant :) (and it's more stable than wpa_supplicant). However, 
> > I'm seeing some unexpected behaviour with the card and another chipset. 
> > When I enable my soundcard (setting volume from 0 to > 0) the wireless 
> > signal seems to drop completely (really funny to see my downloadspeeds go 
> > up and down :) ). My question is, is this normal?
> >
> > However, I'm not sure if this is related to the b43 driver so don't flame 
> > me ;)
> 
> Very strange...my only guess would be EMI generated from your audio
> chipset and/or the speakers in your laptop.
> 
> Is it really just the volume setting?  I.E. if you "play" the audio
> but with the volume turned down does everything work fine?  Does the
> performance continue to degrade as you increase the volume?
> 
> Wierd...I'm not sure what we can do about this...

Heh, yeah. I guess you should buy an FCC rules compliant soundcard instead. ;)
This sounds like EMI.

-- 
Greetings Michael.
