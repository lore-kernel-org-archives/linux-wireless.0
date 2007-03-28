Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:42380 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933638AbXC1GVr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 02:21:47 -0400
Message-ID: <460A0978.2000909@garzik.org>
Date: Wed, 28 Mar 2007 02:21:44 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Please pull 'upstream-fixes' branch of wireless-2.6
References: <20070327182624.GC3887@tuxdriver.com>
In-Reply-To: <20070327182624.GC3887@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> The following changes since commit e0f2e3a06be513352cb4955313ed7e55909acd84:
>   Linus Torvalds (1):
>         Linux 2.6.21-rc5
> 
> are found in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git upstream-fixes
> 
> David Woodhouse (1):
>       bcm43xx: Fix machine check on PPC for version 1 PHY
> 
> Jean Tourrilhes (2):
>       wext: Add missing ioctls to 64<->32 conversion
>       WE-22 : prevent information leak on 64 bit
> 
> Larry Finger (1):
>       bcm43xx: Fix code for confusion between PHY revision and PHY version
> 
> Stefano Brivio (1):
>       bcm43xx: fix radio_set_tx_iq
> 
>  drivers/net/wireless/bcm43xx/bcm43xx_phy.c   |    4 +-
>  drivers/net/wireless/bcm43xx/bcm43xx_radio.c |   12 ++--
>  fs/compat_ioctl.c                            |    9 +++
>  include/linux/wireless.h                     |   21 ++++++-
>  include/net/iw_handler.h                     |   30 +++++++---
>  net/core/rtnetlink.c                         |    3 +-
>  net/core/wireless.c                          |   82 ++++++++++++++++----------
>  7 files changed, 108 insertions(+), 53 deletions(-)

pulled


