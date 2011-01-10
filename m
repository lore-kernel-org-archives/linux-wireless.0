Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33520 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab1AJQFD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 11:05:03 -0500
Received: by eye27 with SMTP id 27so8611506eye.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jan 2011 08:05:02 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Kalle Valo <kvalo@adurom.com>
Subject: Re: 5GHz 802.11n USB Adapter
Date: Mon, 10 Jan 2011 17:03:45 +0100
Cc: Jason Andryuk <jandryuk@gmail.com>, linux-wireless@vger.kernel.org
References: <AANLkTimj11OJRbjO2GBn=C36D7UDUURvguERS5XYoJ7W@mail.gmail.com> <201101082132.22947.helmut.schaa@googlemail.com> <87mxn9fl6m.fsf@purkki.adurom.net>
In-Reply-To: <87mxn9fl6m.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201101101703.45802.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 10. Januar 2011 schrieb Kalle Valo:
> Helmut Schaa <helmut.schaa@googlemail.com> writes:
> 
> > Am Samstag, 8. Januar 2011 schrieb Jason Andryuk:
> >> Are there any limitations for rt2800usb devices?  The wiki is short on
> >> information as is rt2x00.serialmonkey.com.  Does rt2800usb support AP
> >> mode like rt2800pci?
> >
> > rt2800usb does not support bc- and mc- buffering (rt2800pci does). Hence,
> > powersaving stations might experience problems when using rt2800usb in AP
> > mode.
> 
> If some hardware models don't support broadcast/multicast buffering in
> that case the driver shouldn't allow AP mode, at least not in mainline
> kernels. We shouldn't break the standarnd knowingly.
> 
> From a quick grep it looks like rt2800usb enables AP mode. Is that the
> case or did I misunderstood something?

You're right, rt2800usb enables AP mode despite the lack of proper
mc- and bc buffering.

Helmut
