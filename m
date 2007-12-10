Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:43752 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbXLJWAR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 17:00:17 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Doug McLain <doug@nostar.net>
Subject: Re: Problems with b43 using BCM4306 r3
Date: Mon, 10 Dec 2007 22:58:29 +0100
Cc: linux-wireless@vger.kernel.org
References: <475DA27F.2040004@nostar.net>
In-Reply-To: <475DA27F.2040004@nostar.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712102258.29802.mb@bu3sch.de> (sfid-20071210_220022_297097_2549F283)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 10 December 2007 21:33:03 Doug McLain wrote:
> I have an emachines M6805 with the BCM4306 r3 wifi chip.  Using the
> ndiswrapper driver, all is ok, but using the b43 driver results in
> constant flow of dmesg output (see link), eventual lockup of wifi under
> heavy network traffic, and constant xruns when using JACK audio server.
>   Again, when I use the ndiswrapper driver, everything works ok.
> 
> http://nostar.net/ardour/dmesg.txt

That's weird. These messages say that interrupts are not disabled in
the IRQ handler. Which driver are you using? Please try vanilla
wireless-2.6.

-- 
Greetings Michael.
