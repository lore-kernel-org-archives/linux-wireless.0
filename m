Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:53094 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbXBDTlK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Feb 2007 14:41:10 -0500
Date: Sun, 4 Feb 2007 11:41:07 -0800
From: Jouni Malinen <jkmaline@cc.hut.fi>
To: Michael Buesch <mb@bu3sch.de>
Cc: Jon Smirl <jonsmirl@gmail.com>, Pavel Roskin <proski@gnu.org>,
	linux-wireless@vger.kernel.org
Subject: Re: SoftMAC vs FullMAC
Message-ID: <20070204194107.GE6632@jm.kir.nu>
References: <9e4733910702040922n63736d27h7ab027dc90ae8989@mail.gmail.com> <20070204123048.4bhesocg4kosgscg@webmail.spamcop.net> <9e4733910702041031i5edd6dfeq7f8c5179fee5e00e@mail.gmail.com> <200702042007.29357.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200702042007.29357.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 04, 2007 at 08:07:29PM +0100, Michael Buesch wrote:

> If creating and uploading the keys to the device is less work than
> doing crypto in software, then it is clearly a win.

Not necessarily..

> And that _is_ the case for bcm43xx (at least. I don't know about other
> devices' hwcrypto capabilities).
> Doing less on the CPU and more in hw is always a win. I'm not sure
> how you can say that you're not sure it is. ;)

As an example, some of the earlier Prism2 designs supported WEP in
hardware/firmware. Yes, it would free up some host CPU, but the maximum
throughput dropped from ca. 6 Mbps to 4 Mbps (and much lower in some
cases).. WEP is quite fast operation, so using the host CPU to double
throughput sounds like a good trade in many cases.

-- 
Jouni Malinen                                            PGP id EFC895FA
