Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server4.hostdango.com ([70.86.37.74]:35627 "EHLO
	server4.hostdango.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab0KEKWz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Nov 2010 06:22:55 -0400
Message-ID: <4CD3CDB1.2090508@krellan.com>
Date: Fri, 05 Nov 2010 02:26:09 -0700
From: Josh Lehan <krellan@krellan.com>
MIME-Version: 1.0
To: Pavel Machek <pma@sysgo.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: working usb wifi card, that is still possible to buy
References: <20101103092431.GA21138@pma.sysgo.com>
In-Reply-To: <20101103092431.GA21138@pma.sysgo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/03/2010 02:24 AM, Pavel Machek wrote:
> Hi!
> 
> Is there an USB wifi card that can still be bought in reasonable
> ammount (like 1000 pieces) and is well supported by Linux?
> 
> So far I tried carl9170 (as seen by previous mails) and
> rt2x00usb. carl9170 is not really usable; rt2x00usb works a bit
> better, but also fails after some time:

I would like to know as well.  This would be for ARM, though, not
PowerPC.  It's tough finding reliable USB Wi-Fi adapters that work under
Linux these days.  It seems the development focus has shifted to
PCI-based chipsets, unfortunately.

I've had mixed success with the VIA VT6656.  These drivers are only at
"staging" quality within the mainline kernel, though.  There are
separate drivers that can be downloaded directly from the vendor, though.

Anybody else have a good suggestion?

Josh
