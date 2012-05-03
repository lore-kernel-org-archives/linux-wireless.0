Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:39860 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab2ECF0l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 01:26:41 -0400
Date: Thu, 03 May 2012 01:25:02 -0400 (EDT)
Message-Id: <20120503.012502.44731688706812861.davem@davemloft.net> (sfid-20120503_072649_801495_0C6E9377)
To: eric.dumazet@gmail.com
Cc: alexander.duyck@gmail.com, alexander.h.duyck@intel.com,
	netdev@vger.kernel.org, edumazet@google.com,
	jeffrey.t.kirsher@intel.com, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] tcp: cleanup tcp_try_coalesce
From: David Miller <davem@davemloft.net>
In-Reply-To: <1336022373.12425.24.camel@edumazet-glaptop>
References: <1336017985.12425.9.camel@edumazet-glaptop>
	<4FA21087.1080801@gmail.com>
	<1336022373.12425.24.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 03 May 2012 07:19:33 +0200

> My last patch against iwlwifi is still waiting to make its way into
> official tree.
> 
> http://www.spinics.net/lists/netdev/msg192629.html

John, please rectify this situation.

The Intel Wireless folks said they would test it, but that was more
than a month ago.

It's not acceptable to let bug fixes rot for that long, I don't care
what their special internal testing procedure is.

If they give you further pushback, please just ignore them and apply
Eric's fix directly.

Thank you.

