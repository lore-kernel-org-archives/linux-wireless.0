Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:55480 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbYJTJ7h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 05:59:37 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Subject: Re: Regression: USB Wi-Fi Device Removal Panic
Date: Mon, 20 Oct 2008 11:59:12 +0200
Cc: linux-wireless@vger.kernel.org
References: <gdhj21$hdq$1@ger.gmane.org>
In-Reply-To: <gdhj21$hdq$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810201159.12344.mb@bu3sch.de> (sfid-20081020_115946_313047_2C2BF177)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 20 October 2008 11:29:37 Daniel Gimpelevich wrote:
> Using the compat-wireless-old-2008-10-19.tar.bz2 tarball with Ubuntu 
> Hardy's 2.6.24-21-generic kernel, anytime any USB wi-fi device is 
> unplugged, regardless of anything else, the kernel panics. I have 
> confirmed this to occur with a zd1211b device, an rt73 device, and an 
> rtl8187b device. This is especially inconvenient in the rtl8187b case, 
> because after some time, that driver inexplicably stops passing any 
> traffic, seemingly triggered by HTTPS access in Firefox. The panic from 
> removing the rtl8187b device is attached inline, and similar backtraces 
> result from removing the rt73 or the zd1211b.

Any chance you can post a backtrace for zd1211?
I reported a crash-on-pull issue earlier. Just want to check if this is
a different one or the same.

-- 
Greetings Michael.
