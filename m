Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-156-71.gdrpmi.dsl-w.verizon.net ([71.115.156.71]:49413
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702AbZBZVyw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2009 16:54:52 -0500
MIME-Version: 1.0
Date: Thu, 26 Feb 2009 16:54:47 -0500
From: <pat-lkml@erley.org>
To: "Christoph .J Thompson" <cjsthompson@gmail.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: D-Link GWL-122 and AP/WPA2
In-Reply-To: <20090226223155.d2d40946.cjsthompson@gmail.com>
References: <20090226223155.d2d40946.cjsthompson@gmail.com>
Message-ID: <4c9ebaa2648020c2fc9ad54547385f4d@127.0.0.1> (sfid-20090226_225506_135777_620CA3CB)
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 26 Feb 2009 22:31:55 +0100, "Christoph .J Thompson"
<cjsthompson@gmail.com> wrote:
> After trying to get a Sitecom WL-608 wireless USB adapter to work in AP
> mode to no avail I gave up and ordered a Belkin F5D7050 wireless USB
> adapter thinking it used a Prism based chipset which would enable me to
use
> it in AP mode. Almost two weeks later I finally got it this morning
(kudos
> to UPS for the "fast" delivery). To my dismay some clown at Belkin
thought
> it was funny to use a new chipset with each revision of their F5D7050. I
> got a revision "e" which has a Realtek rtl8187 chipset which won't be of
> any use for what I want to do. So I'm back at my starting point with my
> pockets ~50 euros lighter. I'm going to have to buy another USB wifi
> adapter and I'm considering the D-Link GWL-122. It seems that the D-Link
> GWL-122 uses the Prism chipset. Has anyone here any experience with this
> device? Will it work in AP mode with WPA2?

Have you considered other chipsets?  If you HAVE to go with USB, you might
try:

http://www.oxfordtec.com/uk/USB-Wireless-Adapters-802.11b/g---54Mbps/c51_58/p140/SparkLAN-WL-685R-WLAN-802.11g-54Mbps-Wireless-USB-Dongle-%28Ralink-RT2571WF%29---also-LINUX-and-Apple-MAC-OSX-compatible/product_info.html

which is rt2500usb based.  I'll test a rt2500usb device tonight for AP mode
for
ya.  You'll be able to see my results at:  http://wireless.erley.org/

Pat Erley
