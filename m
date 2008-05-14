Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:26510 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756897AbYENDvI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 23:51:08 -0400
Subject: Re: at76_usb driver for WUSB11 v.26 wireless adapter doesn't work
	for kernels newer than 2.6.24.3-12.fc8
From: Pavel Roskin <proski@gnu.org>
To: Fred Odendaal <freshshelf@rogers.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <482A5D2C.7020600@rogers.com>
References: <4820FFCD.7060905@rogers.com> <1210590665.11848.15.camel@dv>
	 <482A5D2C.7020600@rogers.com>
Content-Type: text/plain
Date: Tue, 13 May 2008 23:51:05 -0400
Message-Id: <1210737065.2721.8.camel@rd> (sfid-20080514_055128_494815_3CEA047F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-05-13 at 23:31 -0400, Fred Odendaal wrote:

> I installed Milan's patches (all 8 of them) and it's still broken. I 
> realize that it's nice to have smaller patches for code reviews, but
> for testing it would be a lot easier to have one giant patch.

Actually, it would be great to have them in some git repository for wide
testing.  But I want to take a look at the patches first.

> Is there anyway to get the driver to log messages as it's running? I 
> noticed that "printk" is used a lot. Where would those messages go?

They go to the kernel log, which is shown by the dmesg command.

-- 
Regards,
Pavel Roskin
