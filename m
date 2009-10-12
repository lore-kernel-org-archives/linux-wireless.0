Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36833
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753854AbZJLGIC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 02:08:02 -0400
Date: Sun, 11 Oct 2009 23:07:57 -0700 (PDT)
Message-Id: <20091011.230757.62848864.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: tomasw@gmail.com, linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	yi.zhu@intel.com, inaky.perez-gonzalez@intel.com,
	cindy.h.kao@intel.com, guy.cohen@intel.com,
	ron.rindjunsky@intel.com, tomas.winkler@intel.com, joe@perches.com
Subject: Re: [PATCH 1/3] iwmc3200top: Add Intel Wireless MultiCom 3200 top
 driver.
From: David Miller <davem@davemloft.net>
In-Reply-To: <4AD18C06.8040002@gmail.com>
References: <1ba2fa240910100238s709c31d3s6cb612f502b1086f@mail.gmail.com>
	<20091010.185852.133969433.davem@davemloft.net>
	<4AD18C06.8040002@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sun, 11 Oct 2009 09:40:54 +0200

> diff --git a/MAINTAINERS b/MAINTAINERS
> index e1da925..18244ad 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3654,6 +3654,7 @@ NETWORKING [GENERAL]
>  M:	"David S. Miller" <davem@davemloft.net>
>  L:	netdev@vger.kernel.org
>  W:	http://www.linuxfoundation.org/en/Net
> +W:	http://patchwork.ozlabs.org/project/netdev/list/
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
>  S:	Maintained
>  F:	net/

I've applied this, thanks Eric.
