Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:37885 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124AbXHYGkn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Aug 2007 02:40:43 -0400
Message-ID: <46CFCEE7.4080009@garzik.org>
Date: Sat, 25 Aug 2007 02:40:39 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Please pull 'upstream-jgarzik' branch of wireless-2.6
References: <20070815003637.GK7198@tuxdriver.com>
In-Reply-To: <20070815003637.GK7198@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> A few items intended for 2.6.24.
> 
> Individual patches here:
> 
> 	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/upstream-jgarzik/
> 
> Thanks!
> 
> John
> 
> ---
> 
> The following changes since commit 39d3520c92cf7a28c07229ca00cc35a1e8026c77:
>   Linus Torvalds (1):
>         Linux 2.6.23-rc3
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git upstream-jgarzik
> 
> Daniel Drake (2):
>       zd1211rw: Add ID for Sitecom WL-162
>       zd1211rw: Add ID for ZyXEL M-202 XtremeMIMO
> 
> Mariusz Kozlowski (1):
>       drivers/net/wireless/wl3501_cs.c: remove redundant memset
> 
> Ulrich Kunitz (2):
>       zd1211rw: removed noisy debug messages
>       zd1211rw: consistent handling of ZD1211 specific rates
> 
>  drivers/net/wireless/wl3501_cs.c             |    1 -
>  drivers/net/wireless/zd1211rw/zd_chip.c      |   69 +++++++-----------
>  drivers/net/wireless/zd1211rw/zd_ieee80211.h |   43 +++++++----
>  drivers/net/wireless/zd1211rw/zd_mac.c       |   99 +++++++-------------------
>  drivers/net/wireless/zd1211rw/zd_mac.h       |   65 +++++++++++------
>  drivers/net/wireless/zd1211rw/zd_usb.c       |    2 +
>  6 files changed, 128 insertions(+), 151 deletions(-)

pulled


