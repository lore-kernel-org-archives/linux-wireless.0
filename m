Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:48128
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbXBDUGP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Feb 2007 15:06:15 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Jouni Malinen <jkmaline@cc.hut.fi>
Subject: Re: SoftMAC vs FullMAC
Date: Sun, 4 Feb 2007 21:05:57 +0100
Cc: Jon Smirl <jonsmirl@gmail.com>, Pavel Roskin <proski@gnu.org>,
	linux-wireless@vger.kernel.org
References: <9e4733910702040922n63736d27h7ab027dc90ae8989@mail.gmail.com> <200702042007.29357.mb@bu3sch.de> <20070204194107.GE6632@jm.kir.nu>
In-Reply-To: <20070204194107.GE6632@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702042105.57740.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 04 February 2007 20:41, Jouni Malinen wrote:
> On Sun, Feb 04, 2007 at 08:07:29PM +0100, Michael Buesch wrote:
> 
> > If creating and uploading the keys to the device is less work than
> > doing crypto in software, then it is clearly a win.
> 
> Not necessarily..
> 
> > And that _is_ the case for bcm43xx (at least. I don't know about other
> > devices' hwcrypto capabilities).
> > Doing less on the CPU and more in hw is always a win. I'm not sure
> > how you can say that you're not sure it is. ;)
> 
> As an example, some of the earlier Prism2 designs supported WEP in
> hardware/firmware. Yes, it would free up some host CPU, but the maximum
> throughput dropped from ca. 6 Mbps to 4 Mbps (and much lower in some
> cases).. WEP is quite fast operation, so using the host CPU to double
> throughput sounds like a good trade in many cases.

Yeah, ok. I was more thinking about sane hardware that's actually
capable of doing hwcrypto. :)
Sure, you're right. This prism2 card has to be treated as
swcrypto device, as it's cleary not capable of handling the load.

-- 
Greetings Michael.
