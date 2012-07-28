Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34277 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073Ab2G1TQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jul 2012 15:16:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1SvCUy-0002Ms-0J
	for linux-wireless@vger.kernel.org; Sat, 28 Jul 2012 21:16:24 +0200
Received: from 83.68.239.193 ([83.68.239.193])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jul 2012 21:16:23 +0200
Received: from netuse by 83.68.239.193 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jul 2012 21:16:23 +0200
To: linux-wireless@vger.kernel.org
From: Marco <netuse@lavabit.com>
Subject: Re: RTL8187 in master mode with hostapd
Date: Sat, 28 Jul 2012 21:16:13 +0200
Message-ID: <20120728211613.45ca10fa@homerow> (sfid-20120728_211629_515125_585F088D)
References: <20120727171137.4a1d1ce7@homerow>
	<501405FA.3070504@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-07-28 Larry Finger
<Larry.Finger@lwfinger.net> wrote:

Hi Larry,

> In the case of the RTL8187L, which is the chip in your Alfa device, it means 
> *never*.

Thanks for this straightforward answer. In this case it makes sense
to change the point AP/Master mode on the driver description page

http://linuxwireless.org/en/users/Drivers/rtl8187

from “not working yet” to “not supported”.

> That chip only has a single hardware transmit queue and the work of 
> getting the high-priority traffic, such as beacons, transmitted at the correct 
> time would be much more than it would be worth.

I wasn't aware of that when I bought the device.

It might be off-topic here, but what chip (or device) would you
recommend instead, for use in an AP? It has to be connected via USB,
support master mode and, only if possible, run without the need of
proprietary firmware.


Thanks for taking the time to deal with my issue.

Marco


