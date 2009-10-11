Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gw1.cosmosbay.com ([212.99.114.194]:57068 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbZJKHlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 03:41:49 -0400
Message-ID: <4AD18C06.8040002@gmail.com>
Date: Sun, 11 Oct 2009 09:40:54 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: tomasw@gmail.com, linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	yi.zhu@intel.com, inaky.perez-gonzalez@intel.com,
	cindy.h.kao@intel.com, guy.cohen@intel.com,
	ron.rindjunsky@intel.com, tomas.winkler@intel.com,
	Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/3] iwmc3200top: Add Intel Wireless MultiCom 3200 top
 driver.
References: <1253662724-16497-1-git-send-email-tomas.winkler@intel.com>	<1253662724-16497-2-git-send-email-tomas.winkler@intel.com>	<1ba2fa240910100238s709c31d3s6cb612f502b1086f@mail.gmail.com> <20091010.185852.133969433.davem@davemloft.net>
In-Reply-To: <20091010.185852.133969433.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller a écrit :
> 
> If it's not in netdev patchwork, I don't plan to add it.
> 
> If it is in patchwork, then it's in my backlog and I'll get to it.
> 
> People should never really have to ask me these questions, that's one
> of the main points of:
> 
> 	http://patchwork.ozlabs.org/project/netdev/list/
> 
> You can always see there what's "pending".


Me wondering if this information could be put in MAINTAINERS or Documentation/ something...

I know it only because I caught one of your answer a while ago :)

Either a per project info, or a global ref to http://patchwork.ozlabs.org/

diff --git a/MAINTAINERS b/MAINTAINERS
index e1da925..18244ad 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3654,6 +3654,7 @@ NETWORKING [GENERAL]
 M:	"David S. Miller" <davem@davemloft.net>
 L:	netdev@vger.kernel.org
 W:	http://www.linuxfoundation.org/en/Net
+W:	http://patchwork.ozlabs.org/project/netdev/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
 S:	Maintained
 F:	net/
