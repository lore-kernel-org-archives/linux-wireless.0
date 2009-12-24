Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51235
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753685AbZLXVxN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2009 16:53:13 -0500
Date: Thu, 24 Dec 2009 13:53:14 -0800 (PST)
Message-Id: <20091224.135314.193725771.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2009-12-24
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091224204722.GA678@tuxdriver.com>
References: <20091224204722.GA678@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 24 Dec 2009 15:47:22 -0500

> Dave,
> 
> Here is the usual first batch of pent-up wireless patches after the
> merge window.  It is the usual collection of various driver updates
> along with a dozen or so mac80211/infrastructure changes.  There is
> still more, but lots/most of what remains is dependent not only on this
> batch but also on the fixes that only recently made it into net-next-2.6
> (and which are not yet in wireless-next-2.6).  So, something to look
> forward to... :-)
> 
> Please let me know if there are problems!

Let me know when it builds :-)

awk: /home/davem/src/GIT/net-next-2.6/net/wireless/genregdb.awk: line 29: regular expression compile failed (missing operand)
* Ignore *
awk: /home/davem/src/GIT/net-next-2.6/net/wireless/genregdb.awk: line 33: regular expression compile failed (missing operand)
* Ignore *
make[2]: *** [net/wireless/regdb.c] Error 2
make[2]: *** Waiting for unfinished jobs....
