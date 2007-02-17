Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:47707 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbXBQUYb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Feb 2007 15:24:31 -0500
Message-ID: <45D7647B.8090704@garzik.org>
Date: Sat, 17 Feb 2007 15:24:27 -0500
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Please pull 'upstream' branch of wireless-2.6 (2007-02-14)
References: <20070214212817.GB28318@tuxdriver.com>
In-Reply-To: <20070214212817.GB28318@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> Some late-breaking small and/or important changes before the 2.6.21
> merge window closes...
> 
> ---
> 
> The following changes since commit 46b8c85e1df091fe2d53ae7d02addb0dc58a9123:
>   Larry Finger (1):
>         ieee80211: Fix sparse warning
> 
> are found in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git upstream
> 
> Ahmed S. Darwish (4):
>       ipw2100: Use ARRAY_SIZE macro when appropriate
>       misc-wireless: Use ARRAY_SIZE macro when appropriate
>       hostap: Use ARRAY_SIZE macro when appropriate
>       wavelan: Use ARRAY_SIZE macro when appropriate
> 
> Dan Williams (1):
>       prism54: correct assignment of DOT1XENABLE in WE-19 codepaths
> 
> Daniel Drake (1):
>       zd1211rw: Readd zd_addr_t cast
> 
> Ingo van Lil (1):
>       wireless: fix IW_IS_{GET,SET} comment in wireless.h
> 
> Larry Finger (5):
>       bcm43xx: Janitorial change - remove two unused variables
>       bcm43xx: Fix for oops on resume
>       bcm43xx: Fix for 4311 and 02/07/07 specification changes
>       bcm43xx: OFDM fix for rev 1 cards
>       ieee80211softmac: Fix setting of initial transmit rates
> 
> Michael Buesch (1):
>       bcm43xx: Ignore ampdu status reports

ACK.  Tried to pull, but there were conflicts with netdev#upstream. 
Since there are dependencies in netdev#upstream, looks like you need to 
resend against that.


