Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:51586 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761623AbZLPMO6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2009 07:14:58 -0500
Date: Wed, 16 Dec 2009 13:14:52 +0100
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: Josua Dietze <digidietze@draisberghof.de>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
	Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH] move eject code from zd1211rw to usb-storage
Message-ID: <20091216131452.49ad183b@strolchi.home.s3e.de>
In-Reply-To: <4B28C2F7.7040207@draisberghof.de>
References: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com>
	<4B278191.1010009@draisberghof.de>
	<200912151611.08576.oliver@neukum.org>
	<20091215180300.GF16426@one-eyed-alien.net>
	<20091216114932.4bede511@strolchi.home.s3e.de>
	<4B28C2F7.7040207@draisberghof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 16 Dec 2009 12:22:31 +0100
Josua Dietze <digidietze@draisberghof.de> wrote:

> Stefan Seyfried schrieb:
> > Preferably some code that can be built actually?
> 
> If the "eject" from SCSI tools does not work, "usb_modeswitch" can 
> send customized bulk messages to devices.

for my device, eject seems to be enough, so I'll be trying to get
this into udev.

> http://www.draisberghof.de/usb_modeswitch/

Unfortunately it cannot be built with current libusb and once you
compile it without warnings turned off (which is the default!), you
probably don't want to run it anymore ;)

Having code in kernel has one major advantage: it gets reviewed much
more thoroughly.
-- 
Stefan Seyfried

"Any ideas, John?"
"Well, surrounding them's out."
