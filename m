Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:41415 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932179Ab1AKOqz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 09:46:55 -0500
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Jason Andryuk <jandryuk@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: 5GHz 802.11n USB Adapter
References: <AANLkTimj11OJRbjO2GBn=C36D7UDUURvguERS5XYoJ7W@mail.gmail.com>
	<201101082132.22947.helmut.schaa@googlemail.com>
	<87mxn9fl6m.fsf@purkki.adurom.net>
	<201101101703.45802.helmut.schaa@googlemail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 11 Jan 2011 16:46:54 +0200
In-Reply-To: <201101101703.45802.helmut.schaa@googlemail.com> (Helmut Schaa's message of "Mon\, 10 Jan 2011 17\:03\:45 +0100")
Message-ID: <87ipxvfqg1.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa <helmut.schaa@googlemail.com> writes:

>> If some hardware models don't support broadcast/multicast buffering in
>> that case the driver shouldn't allow AP mode, at least not in mainline
>> kernels. We shouldn't break the standarnd knowingly.
>> 
>> From a quick grep it looks like rt2800usb enables AP mode. Is that the
>> case or did I misunderstood something?
>
> You're right, rt2800usb enables AP mode despite the lack of proper
> mc- and bc buffering.

Ok, thanks. I'll try to come up with a patch which disables AP mode
for rt2800usb.

-- 
Kalle Valo
