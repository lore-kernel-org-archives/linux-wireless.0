Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:36541 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbaDEEOv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Apr 2014 00:14:51 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Andrea Merello <andrea.merello@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net, bernhard@schiffner-limbach.de,
	dan.carpenter@oracle.com
Subject: Re: [PATCH 1/4] rtl8180: change module name in rtl818Xpci
References: <1396628142-14351-1-git-send-email-andrea.merello@gmail.com>
Date: Sat, 05 Apr 2014 07:14:44 +0300
In-Reply-To: <1396628142-14351-1-git-send-email-andrea.merello@gmail.com>
	(Andrea Merello's message of "Fri, 4 Apr 2014 18:15:42 +0200")
Message-ID: <87bnwgif9n.fsf@purkki.adurom.net> (sfid-20140405_061531_590319_E106D288)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrea Merello <andrea.merello@gmail.com> writes:

> From: Larry Finger <Larry.Finger@lwfinger.net>
>
> rtl8180 driver can handle also rtl8185 and rtl8187SE cards,
> however in userspace tools (network manager) it still appares
> as "rtl8180".
> This might lead the user to think the wrong driver is in use.
>
> This patch changes module name to "rtl818Xpci" that should be
> more explanatory.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Andrea Merello <andrea.merello@gmail.com>

[...]

> -obj-$(CONFIG_RTL8180)	+= rtl8180.o
> +obj-$(CONFIG_RTL8180)	+= rtl818Xpci.o

Aren't module names usually all lower case?

-- 
Kalle Valo
