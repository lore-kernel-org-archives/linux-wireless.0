Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:48788 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752271AbXKSJW0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 04:22:26 -0500
Date: Mon, 19 Nov 2007 10:21:17 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	Dan Williams <dcbw@redhat.com>
Subject: Re: [BUG] libertas: probing for Marvell USB8388 fails
Message-ID: <20071119102117.74932cc1@morte> (sfid-20071119_092229_627143_1951DE32)
In-Reply-To: <200711191008.26174.hs4233@mail.mn-solutions.de>
References: <20071117023548.79a7a33c@morte>
	<200711191008.26174.hs4233@mail.mn-solutions.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 19 Nov 2007 10:08:26 +0100
Holger Schurig <hs4233@mail.mn-solutions.de> wrote:

> > Marvell USB8388, running on wireless-2.6. Firmware is:
> > 421964206b0699014a11256ac48dd0a8  /lib/firmware/usb8388.bin
> 
> lsusb says "Bus 001 Device 003: ID 1286:2001".

Same here:
P:  Vendor=1286 ProdID=2001 Rev=30.06

> I use this firmware:
> 
> $ md5sum /lib/firmware/usb8388.bin
> f1dfa0042efd61dc138b01fdf8c0cdab  /lib/firmware/usb8388.bin
> 
> As I got this firmware some months ago (and I hardly use this 
> device), I cannot say which download link I've used.

As long as probing fails, I doubt that my issue is firmware related...

Any clues about how to debug this further?


-- 
Ciao
Stefano
