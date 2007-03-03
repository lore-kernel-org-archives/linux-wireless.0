Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:55226 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992812AbXCCAmK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2007 19:42:10 -0500
Message-ID: <45E8C460.3060400@garzik.org>
Date: Fri, 02 Mar 2007 19:42:08 -0500
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Please pull 'upstream' branch of wireless-2.6
References: <20070227205045.GF5826@tuxdriver.com> <20070227205139.GG5826@tuxdriver.com>
In-Reply-To: <20070227205139.GG5826@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> The following changes since commit 357efd57f229716fd6a1494b970c5a66c0c465ef:
>   Stefano Brivio (1):
>         bcm43xx: fix for 4309
> 
> are found in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git upstream
> 
> John W. Linville (1):
>       wireless: remove obsolete text files
> 
> Larry Finger (1):
>       bcm43xx: Update Documentation/bcm43xx.txt
> 
> Pavel Roskin (1):
>       Use offsetof() instead of own equivalent
> 
> Ulrich Kunitz (1):
>       zd1211rw: changed GFP_NOFS to GFP_KERNEL
> 
> Zhu Yi (1):
>       ipw2200: add channels sysfs entry
> 
>  Documentation/networking/bcm43xx.txt        |   97 +++++++++++++++++++++------
>  drivers/net/wireless/README                 |   25 -------
>  drivers/net/wireless/hostap/hostap_common.h |    4 +-
>  drivers/net/wireless/ipw2200.c              |   47 +++++++++++++
>  drivers/net/wireless/todo.txt               |   15 ----
>  drivers/net/wireless/zd1211rw/zd_chip.c     |    4 +-
>  drivers/net/wireless/zd1211rw/zd_usb.c      |   20 +++---
>  7 files changed, 136 insertions(+), 76 deletions(-)
>  delete mode 100644 drivers/net/wireless/README
>  delete mode 100644 drivers/net/wireless/todo.txt

pulled


