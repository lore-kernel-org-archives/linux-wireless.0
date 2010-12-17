Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52587
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755814Ab0LQVcQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 16:32:16 -0500
Date: Fri, 17 Dec 2010 13:32:44 -0800 (PST)
Message-Id: <20101217.133244.48510021.davem@davemloft.net>
To: mroos@linux.ee
Cc: j@w1.fi, netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [PATCH] hostap: remove netif_stop_queue from init
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.SOC.1.00.1012172324340.24976@math.ut.ee>
References: <alpine.SOC.1.00.1012100918300.15996@math.ut.ee>
	<20101210.094747.193727608.davem@davemloft.net>
	<alpine.SOC.1.00.1012172324340.24976@math.ut.ee>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meelis Roos <mroos@linux.ee>
Date: Fri, 17 Dec 2010 23:27:50 +0200 (EET)

> Fix runtime warning with backtrace from hostap by removing 
> netif_stop_queue() call before register_netdev. Tested to work fine on 
> hostap_pci Prism 2.5.
> 
> Signed-off-by: Meelis Roos <mroos@linux.ee>

Acked-by: David S. Miller <davem@davemloft.net>

John, please apply this.
