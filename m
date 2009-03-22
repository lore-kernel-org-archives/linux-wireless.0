Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39616
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753193AbZCVF53 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 01:57:29 -0400
Date: Sat, 21 Mar 2009 22:57:16 -0700 (PDT)
Message-Id: <20090321.225716.119285539.davem@davemloft.net> (sfid-20090322_065732_897959_636B4274)
To: shemminger@vyatta.com
Cc: j@w1.fi, netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 75/77] hostap: convert to internal net_device_stats
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090321053718.302886142@vyatta.com>
References: <20090321053527.316395697@vyatta.com>
	<20090321053718.302886142@vyatta.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Fri, 20 Mar 2009 22:36:42 -0700

> Use pre-existing net_device_stats in network_device struct.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

Applied.
