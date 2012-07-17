Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:46207 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab2GQFjs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 01:39:48 -0400
Date: Mon, 16 Jul 2012 22:39:47 -0700 (PDT)
Message-Id: <20120716.223947.963699777040428903.davem@davemloft.net> (sfid-20120717_073955_288432_5AB48EBD)
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-usb@vger.kernel.org,
	wimax@linuxwimax.org, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com, linux-s390@vger.kernel.org,
	johannes@sipsolutions.net, uclinux-dist-devel@blackfin.uclinux.org,
	linux-kernel@vger.kernel.org, linux-c6x-dev@linux-c6x.org,
	linux-mips@linux-mips.org,
	user-mode-linux-devel@lists.sourceforge.net,
	user-mode-linux-user@lists.sourceforge.net,
	e1000-devel@lists.sourceforge.net
Subject: Re: [PATCH net-next 0/8] etherdevice: Rename random_ether_addr to
 eth_random_addr
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1342157022.git.joe@perches.com>
References: <1341968967.13724.23.camel@joe2Laptop>
	<cover.1342157022.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Joe Perches <joe@perches.com>
Date: Thu, 12 Jul 2012 22:33:04 -0700

> net-next commit ad7eee98be ("etherdevice: introduce eth_broadcast_addr")
> added a new style API.  Rename random_ether_addr to eth_random_addr to
> create some API symmetry.

Series applied, thanks Joe.
