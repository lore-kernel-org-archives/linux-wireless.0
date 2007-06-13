Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:60189 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261AbXFMC2M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 22:28:12 -0400
Message-ID: <466F5637.10807@garzik.org>
Date: Tue, 12 Jun 2007 22:28:07 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Dan Williams <dcbw@redhat.com>
Subject: Re: Please pull 'libertas-fixes' branch of wireless-2.6
References: <20070529183347.GD3496@tuxdriver.com> <20070612210544.GF310@tuxdriver.com> <20070612210658.GG310@tuxdriver.com>
In-Reply-To: <20070612210658.GG310@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> Fixes identified by the libertas team as important for 2.6.22...
> 
> ---
> 
> The following changes since commit 717c9339202a42ae7bec7d3c4b84deecdcae9f81:
>   Dan Williams (1):
>         libertas: reduce SSID and BSSID mixed-case abuse
> 
> are found in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git libertas-fixes
> 
> Dan Williams (1):
>       libertas: actually send mesh frames to mesh netdev
> 
> Luis Carlos (1):
>       libertas: convert libertas_mpp into anycast_mask
> 
> Luis Carlos Cobo Rus (2):
>       libertas: pull current channel from firmware on mesh autostart
>       libertas: deauthenticate from AP in channel switch
> 
>  drivers/net/wireless/libertas/assoc.c   |   13 +++++++++++++
>  drivers/net/wireless/libertas/assoc.h   |    2 ++
>  drivers/net/wireless/libertas/cmdresp.c |    1 +
>  drivers/net/wireless/libertas/dev.h     |    1 +
>  drivers/net/wireless/libertas/host.h    |    4 ++--
>  drivers/net/wireless/libertas/main.c    |   27 ++++++++++++++-------------
>  drivers/net/wireless/libertas/rx.c      |    5 ++---
>  7 files changed, 35 insertions(+), 18 deletions(-)

pulled into #upstream-fixes


