Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:47960 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbXEXVRY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2007 17:17:24 -0400
Message-ID: <465600E0.5080502@garzik.org>
Date: Thu, 24 May 2007 17:17:20 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: netdev@vger.kernel.og, linux-wireless@vger.kernel.org
Subject: Re: Please pull 'upstream-fixes' branch of wireless-2.6
References: <20070522151751.GA5993@tuxdriver.com>
In-Reply-To: <20070522151751.GA5993@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> The following changes since commit 55b637c6a003a8c4850b41a2c2fd6942d8a7f530:
>   Linus Torvalds (1):
>         Linux v2.6.22-rc2
> 
> are found in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git upstream-fixes
> 
> Eugene Teo (2):
>       drivers/net/wireless/libertas/fw.c: fix use-before-check
>       drivers/net/wireless/libertas/rx.c: fix use-after-free
> 
> Florin Malita (1):
>       libertas: skb dereferenced after netif_rx
> 
>  drivers/net/wireless/libertas/decl.h |    2 +-
>  drivers/net/wireless/libertas/fw.c   |   14 +++++++++-----
>  drivers/net/wireless/libertas/rx.c   |   24 +++++-------------------
>  3 files changed, 15 insertions(+), 25 deletions(-)

pulled


