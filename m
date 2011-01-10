Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:55144 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab1AJEQD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jan 2011 23:16:03 -0500
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Jason Andryuk <jandryuk@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: 5GHz 802.11n USB Adapter
References: <AANLkTimj11OJRbjO2GBn=C36D7UDUURvguERS5XYoJ7W@mail.gmail.com>
	<201101082132.22947.helmut.schaa@googlemail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 10 Jan 2011 06:16:01 +0200
In-Reply-To: <201101082132.22947.helmut.schaa@googlemail.com> (Helmut Schaa's message of "Sat\, 8 Jan 2011 21\:32\:22 +0100")
Message-ID: <87mxn9fl6m.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa <helmut.schaa@googlemail.com> writes:

> Am Samstag, 8. Januar 2011 schrieb Jason Andryuk:
>> Are there any limitations for rt2800usb devices?  The wiki is short on
>> information as is rt2x00.serialmonkey.com.  Does rt2800usb support AP
>> mode like rt2800pci?
>
> rt2800usb does not support bc- and mc- buffering (rt2800pci does). Hence,
> powersaving stations might experience problems when using rt2800usb in AP
> mode.

If some hardware models don't support broadcast/multicast buffering in
that case the driver shouldn't allow AP mode, at least not in mainline
kernels. We shouldn't break the standarnd knowingly.

>From a quick grep it looks like rt2800usb enables AP mode. Is that the
case or did I misunderstood something?

-- 
Kalle Valo
