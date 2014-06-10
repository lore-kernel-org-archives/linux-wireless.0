Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbaFJGmh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2014 02:42:37 -0400
Date: Tue, 10 Jun 2014 08:41:16 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: blue-t@web.de
Cc: linux-wireless@vger.kernel.org
Subject: Re: What is the state of mt7610un mainline support?
Message-ID: <20140610064115.GE1720@redhat.com> (sfid-20140610_084240_196929_A16A4AE8)
References: <7708158.pL1FsGGcj0@nebulos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7708158.pL1FsGGcj0@nebulos>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 08, 2014 at 09:22:10AM +0200, blue-t@web.de wrote:
> i recently bought an AVM!Wlan Stick AC 430 (ID 057c:8501 AVM GmbH) which 
> currently doesn't work at all with 3.15 kernel.
> A magnifying glass revealed that this device is using an mt7610un chipset.
> I tried to add the device id to the mt7610u driver from 
> http://www.mediatek.com/en/downloads/?sort=os but that didn't work out.
[snip]
> Firmware loading wasn't required for the earlier devices from that 
> manufacturer if i understand  the discussion in 
> http://www.spinics.net/lists/linux-wireless/msg123246.html correctly.
> Do we need a similiar fix here?

Adding support for new MT76xx chips to rt2x00 will require quite lot of
work not a single fix.

Stanislaw

