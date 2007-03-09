Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:57908 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767411AbXCIQ6Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2007 11:58:25 -0500
Message-ID: <45F1922E.1010302@garzik.org>
Date: Fri, 09 Mar 2007 11:58:22 -0500
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Please pull 'upstream-fixes' branch of wireless-2.6
References: <20070308033022.GA19886@tuxdriver.com>
In-Reply-To: <20070308033022.GA19886@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> The following changes since commit 08e15e81a40e3241ce93b4a43886f3abda184aa6:
>   Linus Torvalds (1):
>         Linux 2.6.21-rc3
> 
> are found in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git upstream-fixes
> 
> Joerg Sommer (1):
>       bcm43xx: Fix bug in frequency to channel conversion
> 
> Larry Finger (1):
>       bcm43xx: Fix errors in specs to code translation in B6PHY init
> 
> Pavel Roskin (1):
>       bcm43xx: Fix assertion failures in interrupt handler
> 
>  drivers/net/wireless/bcm43xx/bcm43xx_main.c |    6 +++---
>  drivers/net/wireless/bcm43xx/bcm43xx_phy.c  |   10 ++++++++--
>  drivers/net/wireless/bcm43xx/bcm43xx_wx.c   |   10 ++++++++--
>  3 files changed, 19 insertions(+), 7 deletions(-)

pulled


