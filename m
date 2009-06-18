Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.birdnet.se ([213.88.146.6]:50543 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755582AbZFRCzK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 22:55:10 -0400
Message-ID: <20090618025511.27364.qmail@stuge.se>
Date: Thu, 18 Jun 2009 04:55:11 +0200
From: Peter Stuge <peter@stuge.se>
To: "Fabio A. Correa" <facorread@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de
Subject: Re: 4311 not detected at all
References: <ec2083b20906120654j370e5bdo724a7c3b6d505a6c@mail.gmail.com> <4A326771.6030301@lwfinger.net> <ec2083b20906120759x4a8c247eh61d1f6bdb6f194f6@mail.gmail.com> <20090618021017.19879.qmail@stuge.se> <ec2083b20906171932g401fab8fk15531459e1dc4d41@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ec2083b20906171932g401fab8fk15531459e1dc4d41@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fabio A. Correa wrote:
> > You may be able to use flashrom as developed by the coreboot project
> > to flash your BIOS. Maybe. If not, come on IRC or the mailing list
> > and we can try to help you get it to work on your laptop.
> 
> Thank you very much. I emerged it on my Gentoo laptop and the BIOS
> was detected, but:

Please let's move this to a better discussion forum. IRC would be best
for trying to make this work, I think it can work because the BIOS
flashing protection that can be enabled in your chipset does not seem
to be active.

At the very least we need the full output from a run of flashrom -V,
but let's continue the discussion either on IRC (would be best) or on
the coreboot mailing list.

Thanks!


//Peter
