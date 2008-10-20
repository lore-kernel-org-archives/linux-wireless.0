Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:36878 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbYJTOxZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 10:53:25 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Krw8J-0003fH-4s
	for linux-wireless@vger.kernel.org; Mon, 20 Oct 2008 14:53:23 +0000
Received: from gimpelevich.san-francisco.ca.us ([66.218.54.163])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 14:53:23 +0000
Received: from daniel by gimpelevich.san-francisco.ca.us with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 14:53:23 +0000
To: linux-wireless@vger.kernel.org
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Subject: Re: Regression: USB Wi-Fi Device Removal Panic
Date: Mon, 20 Oct 2008 14:53:14 +0000 (UTC)
Message-ID: <gdi60q$hdq$2@ger.gmane.org> (sfid-20081020_165330_482966_A35B435D)
References: <gdhj21$hdq$1@ger.gmane.org> <200810201159.12344.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 20 Oct 2008 11:59:12 +0200, Michael Buesch wrote:

> On Monday 20 October 2008 11:29:37 Daniel Gimpelevich wrote:
>> Using the compat-wireless-old-2008-10-19.tar.bz2 tarball with Ubuntu
>> Hardy's 2.6.24-21-generic kernel, anytime any USB wi-fi device is
>> unplugged, regardless of anything else, the kernel panics. I have
>> confirmed this to occur with a zd1211b device, an rt73 device, and an
>> rtl8187b device. This is especially inconvenient in the rtl8187b case,
>> because after some time, that driver inexplicably stops passing any
>> traffic, seemingly triggered by HTTPS access in Firefox. The panic from
>> removing the rtl8187b device is attached inline, and similar backtraces
>> result from removing the rt73 or the zd1211b.
> 
> Any chance you can post a backtrace for zd1211? I reported a
> crash-on-pull issue earlier. Just want to check if this is a different
> one or the same.

That's exactly what I intended to do all along, since I knew that was the 
most commonly used of the three drivers. I only noticed after I already 
had the panic log and had already put the LapLink cable away that I had 
used the rtl8187b dongle for the test instead of the zd1211b one. I'll 
try to remember to redo the test the next time I need to reboot this 
laptop for anything.

