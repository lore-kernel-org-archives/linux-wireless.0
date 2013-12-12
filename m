Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:50892 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab3LLFdb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 00:33:31 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21161.18818.926049.511664@gargle.gargle.HOWL> (sfid-20131212_063334_669198_97E19B01)
Date: Thu, 12 Dec 2013 10:58:34 +0530
To: Sebastian Moeller <moeller0@gmx.de>
Cc: Stephen Hemminger <stephen@networkplumber.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: Fw: [Cerowrt-devel] Wireless failures 3.10.17-3
In-Reply-To: <20131211174519.34966001@nehalam.linuxnetplumber.net>
References: <20131211174519.34966001@nehalam.linuxnetplumber.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sebastian,

> I think I can make tho error appear "at will" by running netperf-wrapper
> against my wndr3700v2, just tested under 3.10.21-1:
> /netperf-wrapper -l 300 -H gw.home.lan rrul -p all -t hms-beagle_cerowrt3.10.21-1_2_nacktmulle
> 
> dmesg on the router:
> [   53.007812] IPv6: ADDRCONF(NETDEV_CHANGE): gw11: link becomes ready
> [28792.039062] ath: phy1: Failed to stop TX DMA, queues=0x00e!
> [28794.078125] ath: phy1: Failed to stop TX DMA, queues=0x00e!
> [28807.164062] ath: phy1: Failed to stop TX DMA, queues=0x00e!
> [28809.191406] ath: phy1: Failed to stop TX DMA, queues=0x002!
> [28823.269531] ath: phy1: Failed to stop TX DMA, queues=0x00e!

What board is this ? Can you post the initial bootlog ?

Sujith
