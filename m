Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:57922 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767410AbXCIQ7n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2007 11:59:43 -0500
Message-ID: <45F1927D.8040805@garzik.org>
Date: Fri, 09 Mar 2007 11:59:41 -0500
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Please pull 'upstream' branch of wireless-2.6
References: <20070308033022.GA19886@tuxdriver.com> <20070308033226.GB19886@tuxdriver.com>
In-Reply-To: <20070308033226.GB19886@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> The following changes since commit 9b73d945c4269f61d2ecf0555150b577a965bc99:
>   John W. Linville (1):
>         Merge branch 'upstream-fixes' into upstream
> 
> are found in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git upstream
> 
> Andrew Morton (1):
>       ipw2200: fix ieee80211_get_geo typo
> 
> Jouni Malinen (1):
>       hostap: Add D-Link DWL-650 Rev. P1 product id
> 
> Sam Ravnborg (1):
>       bcm43xx: do not rebuild when kernel version changes
> 
>  drivers/net/wireless/bcm43xx/bcm43xx_ethtool.c |    4 ++--
>  drivers/net/wireless/hostap/hostap_cs.c        |    5 +++++
>  drivers/net/wireless/ipw2200.c                 |    2 +-
>  3 files changed, 8 insertions(+), 3 deletions(-)
> 

pulled



