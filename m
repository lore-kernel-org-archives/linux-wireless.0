Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server11.hostfactory.ch ([62.146.13.133]:47418 "EHLO
	server11.hostfactory.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbbGMLwb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2015 07:52:31 -0400
Message-ID: <55A3A672.1060502@weiss.ch> (sfid-20150713_135234_934117_76B2127D)
Date: Mon, 13 Jul 2015 13:52:18 +0200
From: Rolf Anderegg <rolf.anderegg@weiss.ch>
Reply-To: rolf.anderegg@weiss.ch
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k_htc: virtual interfaces, AP connection drop & kernel warning
References: <559D41B3.4050604@weiss.ch> <559F9AF8.5000208@rempel-privat.de>
In-Reply-To: <559F9AF8.5000208@rempel-privat.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> First of all, you are using ancient kernel and firmware. Please update
> it. Firmware should be at leas 1.4 and kernel probably 4.1 or later. i'm
> not sure which include patch with support of RMW command introduced by
> new FW.
>
> Then you can try to disable LED blinking which is stealing your usb
> bandwidth.

Thanks for your suggestions.
You say ancient, I was thinking longterm stable. For various reasons I
require a RT patched kernel, alas this is not yet available for 4.1
kernels. Aside from that I have updated the kernel and firmware as you
propose. Also I have set ath9k_htc's blink=0. The kernel warnings are no
longer occuring, however the AP's connection (which requires several
attempts) is still dropped after a few seconds.
I suspect that there are bandwidth/speed issues when dealing with USB
adapters, but that does not inherently mean that the connection is prone
to drop, right? Doesn't that mean that I am leaking packages somewhere
along the way? What else could I be looking for?

Regards,
Rolf Anderegg
