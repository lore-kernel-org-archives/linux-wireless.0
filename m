Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40760 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756508AbZJBGwk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 02:52:40 -0400
From: Malte Gell <malte.gell@gmx.de>
To: Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: [PATCH] ar9170usb: LEDs are confused
Date: Fri, 2 Oct 2009 08:52:36 +0200
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, linville@tuxdriver.com
References: <200910011654.10963.chunkeey@googlemail.com>
In-Reply-To: <200910011654.10963.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200910020852.36427.malte.gell@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Christian Lamparter <chunkeey@googlemail.com> wrote

> On 2009-10-01 06:32 AM, Malte Gell wrote:
> >I first noticed the LEDs are confused,
> 
> no, the LED colors is not _confused_ at all.
> This is simply different on.... well, you know: on a per-device base!

Yeah, I guessed it. But, guess... i am not a real hacker so my dirty little 
patch just is a trial by combat solution for my own boy ;-)
 
> For example: The Netgear uses a single bi-color LED for their WNDA3100
>  stick. It glows blue or/and orange depending on the selected band and
>  current operation mode and state...

The Netgear (WN?) 111 even only has one blue LED as far as I know. And 
Neatgear sticks look ugly.
 
> FYI: you can assign the LEDs under "/sys/class/leds/" with a different
>  tigger without messing with the kernel source... An up-to-date README can
>  be found in the kernel's documentation directory:
>  Documentation/leds-class.txt , or you can look it up online as well:
> http://www.mjmwired.net/kernel/Documentation/leds-class.txt (from 2.6.31)

Very good to know. This needs a udev rule, right?

But, what about a USB ID based decission in the driver how to handle the LED? 
I have a Fritz WLAN N, USB ID:  057c:8401

Regards
Malte
