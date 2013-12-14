Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:43060 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab3LNEFt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Dec 2013 23:05:49 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21163.55288.562709.691719@gargle.gargle.HOWL> (sfid-20131214_050552_931520_352EE117)
Date: Sat, 14 Dec 2013 09:30:56 +0530
To: Dave Taht <dave.taht@gmail.com>
Cc: Sebastian Moeller <sebastian.moeller@gmail.com>,
	"ath9k-devel\@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"cerowrt-devel\@lists.bufferbloat.net"
	<cerowrt-devel@lists.bufferbloat.net>
Subject: Re: [Cerowrt-devel] Wireless failures 3.10.17-3
In-Reply-To: <CAA93jw7Tj+jdapc-OWFr1LDYQDx3r6crafk302jXJaa3va43-A@mail.gmail.com>
References: <20131211174519.34966001@nehalam.linuxnetplumber.net>
	<21161.18818.926049.511664@gargle.gargle.HOWL>
	<C0DD393A-6810-4CB6-B705-AE801ED5BBBA@gmx.de>
	<21162.54025.118938.614891@gargle.gargle.HOWL>
	<CAA93jw5tOoYGB5Q=vFT6N_G7-KEjGC7=oxH2CwpM9FMT+J_A7g@mail.gmail.com>
	<CAA93jw7Tj+jdapc-OWFr1LDYQDx3r6crafk302jXJaa3va43-A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dave Taht wrote:
> OK, I couldn't help myself but boot up that release. Wet paint! It
> successfully brought up
> the 5ghz radio, but did not manage to assign an ip address to it
> (netifd bug?) and failed on the 2ghz radio utterly.
> 
> trying to restart it manually fails to bring up the 5ghz radio as well.
> Here's an strace of that.
> 
> http://snapon.lab.bufferbloat.net/~d/hostapd.strace.txt
> 
> I don't see it beacon, either.
> 
> Now, I don't have a grip on what started happening two releases back
> (I was out of town) but I figure it is perhaps more relevant than
> chasing the DMA tx thing. And ENOTIME for me on this til sunday. I
> will revert this patch and bisect backwards.

I am not sure how the patch would break things.

Booting OpenWrt trunk (with the patch) on an AP96 reference board seems
to work fine: http://pastebin.com/3rPSfuad

Sujith
