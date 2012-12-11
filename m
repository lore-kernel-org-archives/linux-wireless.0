Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:34712 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab2LKEt0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 23:49:26 -0500
Date: Mon, 10 Dec 2012 23:49:23 -0500 (EST)
Message-Id: <20121210.234923.94776338088489257.davem@davemloft.net> (sfid-20121211_054942_189422_EA637D4E)
To: abhi.c.pawar@gmail.com
Cc: pablo@netfilter.org, kaber@trash.net, kuznet@ms2.inr.ac.ru,
	jmorris@namei.org, yoshfuji@linux-ipv6.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, amwang@redhat.com, edumazet@google.com,
	nhorman@tuxdriver.com, joe@perches.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, coreteam@netfilter.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH RESEND RESEND] net: remove obsolete simple_strto<foo>
From: David Miller <davem@davemloft.net>
In-Reply-To: <1355196860-10708-1-git-send-email-abhi.c.pawar@gmail.com>
References: <1355196860-10708-1-git-send-email-abhi.c.pawar@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijit Pawar <abhi.c.pawar@gmail.com>
Date: Tue, 11 Dec 2012 09:04:20 +0530

> This patch replace the obsolete simple_strto<foo> with kstrto<foo>
> 
> Signed-off-by: Abhijit Pawar <abhi.c.pawar@gmail.com>

You can't submit replacement patches for ones which I have already
applied.

Patches I apply are permanently applied, and therefore you must submit
changes relative the ones I've applied already.
