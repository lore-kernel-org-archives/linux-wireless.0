Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alephnull.demon.nl ([83.160.184.112]:51973 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbXJZWXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 18:23:53 -0400
Date: Fri, 26 Oct 2007 23:58:05 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
	rmk@arm.linux.org.uk, kernel@wantstofly.org, tony.luck@intel.com,
	jwboyer@linux.vnet.ibm.com, benh@kernel.crashing.org,
	paulus@samba.org, dmitry.torokhov@gmail.com,
	netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-serial@vger.kernel.org, linux-wireless@vger.kernel.org,
	bryan.wu@analog.com, adaplas@gmail.com
Subject: Re: [PATCH] Remove pointless casts from void pointers,
Message-ID: <20071026215805.GD32372@xi.wantstofly.org> (sfid-20071026_232400_026062_35FBECC9)
References: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 26, 2007 at 05:40:22AM -0400, Jeff Garzik wrote:

>  arch/arm/mach-pxa/ssp.c                    |    2 +-
>  arch/arm/mach-s3c2410/usb-simtec.c         |    2 +-
>  arch/arm/plat-omap/mailbox.c               |    2 +-

FWIW

Acked-by: Lennert Buytenhek <buytenh@wantstofly.org>
