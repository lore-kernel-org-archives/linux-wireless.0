Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:64385 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbZFHX7l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 19:59:41 -0400
Received: by fxm9 with SMTP id 9so2602011fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2009 16:59:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f76a32050906081011o589474f2geba321c58c0872c2@mail.gmail.com>
References: <f76a32050906081007q19e9361w8c1fad6fc73c47e7@mail.gmail.com>
	 <f76a32050906081011o589474f2geba321c58c0872c2@mail.gmail.com>
Date: Tue, 9 Jun 2009 00:59:42 +0100
Message-ID: <3ace41890906081659o23cb9ee1sd82ca4fc28a3793d@mail.gmail.com>
Subject: Re: Testing AP mode with WLAN-USB-Stick: How to obtain?
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Stefan Steuerwald <salsasepp@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 8, 2009 at 6:11 PM, Stefan
Steuerwald<salsasepp@googlemail.com> wrote:
> Dear all,
>
> I have tried unsuccessfully to obtain any WLAN USB stick with a
> chipset that supports AP mode.
> This is for testing a mobile device that is supposed to work as an AP
> with iPod/iPhone life forms.
>
> There only seem to be two choices: p54usb-based (preferred) and
> rt2500-based devices. No luck in buying any of the listed devices
> (they seem obsolete).
> Turns out that anything current I can buy probably has RTL8187, RT73
> or RT2800, and anything used I get from ebay is not what it seems
> ("Netgear WG111 v2" can mean at least two different things I know of,
> both unsuitable).
>
> Any pointers on
> a) where to click-and-buy a stick that supports AP mode, or
> b) whom to send money in exchange for a used stick are VERY much appreciated.

At the risk of being yelled at, if you use the vendor driver (not the
rw driver), Zydas zd1211 based USB stick can be made to work in AP
mode. Caveats are (1) the vendor driver is known *not* to work on
64-bit host, and unlikely on anything but 32-bit intel linux, (2) you
need a bunch of patches I posted earlier to build against current
kernels. Search the archive.
The zd1211 is quite popular for USB sticks.
