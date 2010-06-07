Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:43638 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227Ab0FGNhu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 09:37:50 -0400
Subject: Re: kernel 2.6.35-rc1 on avila ixp4xx board booting problem
From: Pavel Roskin <proski@gnu.org>
To: Stefan <dhj58ad@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4C0CCE51.7080403@googlemail.com>
References: <4C0CCE51.7080403@googlemail.com>
Content-Type: text/plain
Date: Mon, 07 Jun 2010 09:37:46 -0400
Message-Id: <1275917866.9796.5.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-06-07 at 03:47 -0700, Stefan wrote:

> I just compiled the kernel from wireless-testing git tree for my
> gateworks avila ixp4xx  board. I used the OpenWrt toolchain for cross
> compiling for the arm - architecture and I used the .config of the
> original kernel of OpenWrt (2.6.32-10)
> 
> The kernel hangs up directly after being uncompressed.
...
> console output:

> Uncompressing Linux... done, booting the kernel.
> 
> I don't know, how to debug such behaviour. Any suggestions would be
> extremely helpful.
> I attached my kernel config.

Ypou are posting to a wrong mailing list.
linux-wireless@vger.kernel.org is about wireless drivers.  I see no
evidence that wireless drivers have anything to do with your problem.

Please look for mailing lists about embedded devices and ARM.

-- 
Regards,
Pavel Roskin
