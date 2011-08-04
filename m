Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865Ab1HDPJ0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Aug 2011 11:09:26 -0400
Date: Thu, 4 Aug 2011 17:09:31 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alan Piszcz <ap@solarrain.com>
Subject: Re: Linux Wireless USB-Stick Question
Message-ID: <20110804150930.GA4202@redhat.com> (sfid-20110804_170946_141173_0C6315B8)
References: <alpine.DEB.2.02.1108031550100.4278@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.DEB.2.02.1108031550100.4278@p34.internal.lan>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 03, 2011 at 03:53:51PM -0400, Justin Piszcz wrote:
> Under Windows, you can achieve 10-15MiB/s..
> 
> Under Linux, even with 150mbps USB wireless adapters, the max never
> appears to go above > 3-4MiB/s, to work around this, order more
> USB-wifi ticks and run them in parallel far away from each other
> with USB
> extenders:
> 
> box1:
> -------------
> wlan0     IEEE 802.11bg  ESSID:"hidden"
>           Bit Rate=54 Mb/s   Tx-Power=20 dBm
> wlan1     IEEE 802.11bgn  ESSID:"hidden"
>           Bit Rate=58.5 Mb/s   Tx-Power=20 dBm
> wlan2     IEEE 802.11bgn  ESSID:"hidden"
>           Bit Rate=39 Mb/s   Tx-Power=20 dBm
> 
> box2:
> -------------
> wlan0     IEEE 802.11bgn  ESSID:"hidden"
>           Bit Rate=58.5 Mb/s   Tx-Power=20 dBm
> wlan1     IEEE 802.11bgn  ESSID:"hidden"
>           Bit Rate=52 Mb/s   Tx-Power=20 dBm
> wlan2     IEEE 802.11bgn  ESSID:"hidden"
>           Bit Rate=52 Mb/s   Tx-Power=20 dBm
> 
> But I was curious if anyone had achieved > 10 MiB/s with any
> wireless adapter with Linux?

Well, if your AP which you are connected from Windows host
has linux based firmware (what is most probable), then linux
is capable to transfer also at 10-15 MiB/s :-)

But yes, I never achieved more than 10MB/s on linux station.
Best results I have is about 7.5MB/s on 2.4 GHz networks and
10MB/s on 5GHz .

Stanislaw

