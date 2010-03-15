Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49254 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S964804Ab0COKXP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Mar 2010 06:23:15 -0400
From: Malte Gell <malte.gell@gmx.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: Kernel 2.6.33: ar9170.fw firmware file not found
Date: Mon, 15 Mar 2010 11:23:10 +0100
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
References: <201003040835.29387.malte.gell@gmx.de> <201003110933.18581.malte.gell@gmx.de> <1268331935.1915.19.camel@mj>
In-Reply-To: <1268331935.1915.19.camel@mj>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201003151123.11244.malte.gell@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Pavel Roskin <proski@gnu.org> wrote

> I compiled a kernel with your config on plain 2.6.33.  I'm using the
> x86_64 architecture, so "make oldconfig" asked a few questions, but
> nothing important.
> 
> I'm running that kernel with no problems.  The driver loads and works
> fine.  Here's the output of udevadm monitor:

I am not using a vanilla kernel, but a 2.6.33 from openSUSE, heaven knows what 
they have added to the kernel...

> It looks like you get no USB events.  Also, the output looks
> differently.  KERNEL events are called UEVENT in your log.
> 
> Maybe you could try another USB port, just in case?  I would probably
> add debugging to the udev scripts to see what they are doing.  Maybe
> there is an update for udev for your system?
> 
> Perhaps you should find another forum to ask questions about udev.  I
> think the kernel is not a suspect anymore.

Thanks so far, I will try that.

Regards
Malte
 
