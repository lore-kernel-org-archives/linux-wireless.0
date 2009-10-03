Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38117 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752741AbZJCR33 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Oct 2009 13:29:29 -0400
From: Malte Gell <malte.gell@gmx.de>
To: Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: [PATCH] ar9170usb: LEDs are confused
Date: Sat, 3 Oct 2009 19:28:38 +0200
Cc: Joerg Albert <jal2@gmx.de>, linux-wireless@vger.kernel.org
References: <200910011654.10963.chunkeey@googlemail.com> <200910030453.42131.malte.gell@gmx.de> <200910031329.47123.chunkeey@googlemail.com>
In-Reply-To: <200910031329.47123.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200910031928.39288.malte.gell@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Christian Lamparter <chunkeey@googlemail.com> wrote

> On Saturday 03 October 2009 04:53:41 Malte Gell wrote:
> > Can I change the link(s) there at any time
> 
> yes, you can change then any time you want.

> > That's true! I just had to exchange the words "tx" with "assoc"
> > in the driver,  whereas a udev rule is complicated!
> 
> well, there's at least one upside: this rule could be easily
> modified to work with different wireless drivers.

Maybe a udev rule would even be the best solution, this way Linux distributors 
could easily adapt it to different hardware.
 
> by the way: Could you please do me a flavour (since you are
> the only WN111 v2 owner I know) and tell us what "hwtype"
> result you get with Joerg Albert's patch:
> 
> http://marc.info/?l=linux-wireless&m=125452461322729&q=raw

I'm so sorry, I do not have the WN111v2 any more! I gave it back a few days 
ago after I was able to get the Fritz WLAN N running... I had the WN111v2 just 
for a few days while the Fritz wasn't running.

Regards
Malte
