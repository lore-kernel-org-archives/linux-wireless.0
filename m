Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbYG0PBa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2008 11:01:30 -0400
Subject: Re: ath9k working, almost
From: Dan Williams <dcbw@redhat.com>
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200807261742.15693.alistair@devzero.co.uk>
References: <200807261742.15693.alistair@devzero.co.uk>
Content-Type: text/plain
Date: Sun, 27 Jul 2008 10:59:21 -0400
Message-Id: <1217170761.2700.12.camel@localhost.localdomain> (sfid-20080727_170133_473274_068FDFD6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-07-26 at 17:42 +0100, Alistair John Strachan wrote:
> Hi,
> 
> The newly announced ath9k driver works great on an AR5418 Core 2 Duo Macbook, 
> WPA2-TKIP/AES et al all work fine. It would be good to see this driver in 
> wireless-testing, it completely replaces madwifi for me. I used linux.git 
> (2.6.26) + wireless-testing.git + my-wireless-testing.git with success.
> 
> The only thing that I couldn't get working was the signal strength meter in 
> knetworkmanager. The AP signal strength shows up in iwlist ath0 scanning, but 
> whatever NM uses doesn't seem to work. All is good with madwifi, by 
> comparison.
> 
> Any ideas? NM issue?

The signal strength code in NM hasn't changed for quite a long time.
Chances are it's the driver not reporting correctly.  What's the
iwconfig output for while you're connected to your AP?

 Link Quality=92/100  Signal level=-36 dBm  Noise level=-91 dBm

That's the line I care about.

Dan

