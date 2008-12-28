Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:58490 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbYL1JeN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Dec 2008 04:34:13 -0500
Received: by ewy10 with SMTP id 10so4595813ewy.13
        for <linux-wireless@vger.kernel.org>; Sun, 28 Dec 2008 01:34:10 -0800 (PST)
To: Piter PUNK <piterpunk@unitednerds.org>
Subject: Re: rt2500usb vs rt73usb
Date: Sun, 28 Dec 2008 10:34:07 +0100
Cc: linux-wireless@vger.kernel.org
References: <49571E29.8060204@unitednerds.org>
In-Reply-To: <49571E29.8060204@unitednerds.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812281034.07373.IvDoorn@gmail.com> (sfid-20081228_103422_107974_4D7FBEDF)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 28 December 2008, Piter PUNK wrote:
> 
> Hi,
> 
> I have three rt2573 wireless devices:
> 
> . TP-Link WN321G
> . D-Link DWA-110
> . Built-in inside Intel ClassmatePC
> 
> The D-Link device loads only the rt73usb module and
> works really fine. The other two loads rt73usb AND
> rt2500usb. The correct module for all is rt73usb.
> 
> Loading rt2500usb AND rt73usb don't have any functional
> problem. All wireless devices works fine. But is very
> annoying the additional modules loaded.
> 
> Both modules are loaded because both handle 148f:2573
> devices. Of course my universe is very small, only two
> devices, but... devices 148f:2573 that works with
> rt2500usb exists? Those devices can work with rt73usb?

rt2500usb and rt73usb drivers are for different chipsets,
so when rt73usb works for a particular chip the rt2500usb
driver will not work for that same chip.

> If the those 148f:2573 USB devices doesn't exists or
> if they exists and works fine with rt73usb, can we
> remove 148f:2573 from rt2500usb?

No we can't, you can blame manufacturers for shipping
USB sticks with different chipsets but the exact same USB ID.

Ivo
