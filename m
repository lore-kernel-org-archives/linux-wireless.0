Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web28316.mail.ukl.yahoo.com ([87.248.110.135]:42357 "HELO
	web28316.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752851AbZIJVpN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 17:45:13 -0400
Message-ID: <213140.53030.qm@web28316.mail.ukl.yahoo.com>
Date: Thu, 10 Sep 2009 21:45:14 +0000 (GMT)
From: Albert Herranz <albert_herranz@yahoo.es>
Subject: Re: [PATCH] b43: Add Soft-MAC SDIO device support
To: Michael Buesch <mb@bu3sch.de>,
	=?iso-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>
In-Reply-To: <69e28c910909101423j535c9cffq5b1be1cb00877645@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- El jue, 10/9/09, Gábor Stefanik <netrolller.3d@gmail.com> escribió:
> > This adds support for Soft-MAC SDIO devices to b43.
> > The driver still lacks some fixes for SDIO devices, so
> it's currently
> > marked as BROKEN.
> 
> Is it actually completely broken; or already testable, just
> incomplete?
> 

It doesn't work yet as posted to the ML. So I'd say, it is not testable.

We'll work to bring it into an usable form, then mark it unbroken.

Cheers,
Albert



      
