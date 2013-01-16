Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:37046 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128Ab3APBOm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jan 2013 20:14:42 -0500
Received: by mail-la0-f47.google.com with SMTP id fh20so815092lab.6
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jan 2013 17:14:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50F5E399.30008@gmx.de>
References: <50F5E399.30008@gmx.de>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 16 Jan 2013 12:14:20 +1100
Message-ID: <CAGRGNgWoz0wx7Aco_FC_VhVnecL0kQM6OBqRU-3PJed3hZJaLA@mail.gmail.com> (sfid-20130116_114546_466680_F33CF9B3)
Subject: Re: Intel Pro Wireless 2100 Driver linux
To: Felix Wabra <felix.wabra@gmx.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Felix,

On Wed, Jan 16, 2013 at 10:17 AM, Felix Wabra <felix.wabra@gmx.de> wrote:
>   Dear Sourceforge.net Team

This isn't sourceforge, sourceforge is a place that hosts projects,
they don't actually work on them. This is the Linux Wireless mailing
list, we work on drivers for wireless cards for Linux.

> Would it be possible, that you send me the Driver for the Intel Pro WIreless
> 2100 lan 3B mini PCI.

The driver is called ipw2100 and is part of the Linux Kernel.

Your distribution should already have it enabled (most do) so once the
kernel detects the device, it'll be automatically loaded, so once
you've installed the firmware, it should work.

The firmware is usually available as a package called
"firmware-ipw2x00" or "firmware-ipw2100" or something similar. I'm not
familiar with Backtrack Linux so I don't know the exact package name.

If your distribution doesn't have it enabled, then you will need to
compile your own kernel, following the instructions provided by your
distribution and ensure that this driver is enabled.

Also, the driver is quite old and has not been converted to the new
wireless framework, so you may need to install the deprecated wireless
tools to utilise it.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
