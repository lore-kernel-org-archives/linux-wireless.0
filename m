Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:37276 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356Ab0EZWGO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 18:06:14 -0400
Subject: Re: Realtek rtl8188 support?
From: Pavel Roskin <proski@gnu.org>
To: Paul Thomas <pthomas8589@gmail.com>
Cc: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
In-Reply-To: <c785bba31003291519tfd7d26fy466a4ee4310ac590@mail.gmail.com>
References: <c785bba31003060945j22be2e78pfeaa1bcd39fcba2c@mail.gmail.com>
	 <69e28c911003061007y258ec349laa802810e0517de4@mail.gmail.com>
	 <1267949782.15192.13.camel@mj>
	 <69e28c911003070736t678cf6ccld0fe6dc332f4380d@mail.gmail.com>
	 <1268190973.10669.12.camel@mj>
	 <c785bba31003291519tfd7d26fy466a4ee4310ac590@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 26 May 2010 18:06:09 -0400
Message-Id: <1274911569.2593.8.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-03-29 at 15:19 -0700, Paul Thomas wrote:
> OK, I'd love to get to where Pavel & Gabor are, but I think I'm having
> trouble with the PCI dependency. I'm on an arm platform without PCI
> (atmel at91sam9g20). If I remove the PCI dependency from the Kconfig
> it does compile with warnings, and then when the module loads I get
> "r8192s_usb: Unknown symbol wireless_send_event".
> 
> I'm happy to hang out and try again when the driver leaves staging,
> but I thought I might mention the PCI dependency now.

wireless_send_event should be available if WIRELESS_EXT is selected in Kconfig.

But I cannot find the "r8192s_usb" symbol in any staging drivers, so I
have no idea which driver you are talking about.

I suggest that you don't hijack existing threads to report new issues.
When reporting a problem, please give the kernel version, the driver
name and whatever details are needed for others to reproduce the
problem.

> > CCMP is working, and I could browse the web over it!

Please don't quote parts of the message that are irrelevant to what you
are saying.

-- 
Regards,
Pavel Roskin
