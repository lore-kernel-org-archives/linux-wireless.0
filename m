Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56802.mail.re3.yahoo.com ([66.196.97.76]:30692 "HELO
	web56802.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750794Ab0IFKLh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Sep 2010 06:11:37 -0400
Message-ID: <830552.64105.qm@web56802.mail.re3.yahoo.com>
Date: Mon, 6 Sep 2010 03:04:55 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: rt2x00usb_watchdog_tx_status: Warning - TX queue 2 status timed out, invoke forced tx handler
To: Michael <msbroadf@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTi=5P8N6QDDZkVuFwCMDzBTLsCkiOem0_WwL-hvS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is this why the rt307x chips experience considerable amount of packet loss  in managed mode, when connected to an AP? With the rt2870sta drivers and a rt3070 device I experience no packet loss whatsoever. When rt2800usb is being utilized, large amount of packet loss occurs between the client and AP as well as duplicate packets.

Walt

> It is being worked on, but it cannot be fully resolved. It
> is
> currently simply a fact
> that the DMA can lockup in the device even the official
> Ralink driver
> has a watchdog
> function which resets the TX queue whenever it detects the
> lockup.
>
> I am currently working on improving the detection, since
> there can be
> a DMA timeout
> and a TX status report timeout. (Where the latter occurs
> much more
> often then the DMA
> timeout). This should decrease the packet loss somewhat,
> but will not
> prevent the
> problems to occur.
>
> Ivo


      
