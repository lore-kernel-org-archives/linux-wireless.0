Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:45080 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbYFLRNJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 13:13:09 -0400
Subject: Re: [OOPS] rt2x00: unplugging an rt73 device oops at
	usb_kill_urb+0x14/0xd0
From: Pavel Roskin <proski@gnu.org>
To: Nicolas Deschildre <ndeschildre@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <5ff0631c0806120925m1e00482du5175c9b9a2f7f4dd@mail.gmail.com>
References: <5ff0631c0806120925m1e00482du5175c9b9a2f7f4dd@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 13:13:06 -0400
Message-Id: <1213290786.2408.2.camel@dv> (sfid-20080612_191312_604644_006D8298)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-06-12 at 18:25 +0200, Nicolas Deschildre wrote:
> I tried the wireless compatibilty stack from the 5 June.
> When unplugging a RT73 device from its USB slot, I get the following
> oops :
...
> [  703.841832] EIP: [<e089fee4>] usb_kill_urb+0x14/0xd0 [usbcore]
> SS:ESP 0068:ddf61e10

This is fixed in today's wireless-testing.
compat-wireless-2008-06-12.tar.bz2 appears to contain the fix already.

-- 
Regards,
Pavel Roskin
