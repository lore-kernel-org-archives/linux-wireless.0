Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yue.linux-ipv6.org ([203.178.140.15]:46918 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbXI0MEB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 08:04:01 -0400
Date: Thu, 27 Sep 2007 21:05:42 +0900 (JST)
Message-Id: <20070927.210542.72712364.yoshfuji@linux-ipv6.org>
To: larry.finger@lwfinger.net
Cc: jt@hpl.hp.com, linville@tuxdriver.com, mb@bu3sch.de,
	linux-wireless@vger.kernel.org, davem@davemloft.net,
	torvalds@linux-foundation.org, yoshfuji@linux-ipv6.org
Subject: Re: 2.6.23-rc regression: bcm43xx does not work after commit  4cf92a3c
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?=
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <20070925.122951.98475715.yoshfuji@linux-ipv6.org>
References: <20070925.115054.25066958.yoshfuji@linux-ipv6.org>
	<46F87B27.5040106@lwfinger.net>
	<20070925.122951.98475715.yoshfuji@linux-ipv6.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In article <20070925.122951.98475715.yoshfuji@linux-ipv6.org> (at Tue, 25 Sep 2007 12:29:51 +0900 (JST)), YOSHIFUJI Hideaki / 吉藤英明 <yoshfuji@linux-ipv6.org> says:

> In article <46F87B27.5040106@lwfinger.net> (at Mon, 24 Sep 2007 22:06:15 -0500), Larry Finger <larry.finger@lwfinger.net> says:
> 
> > The right fix is in the chain. I sent it to John Linville who has sent it to Jeff Garzik. I
> > certainly hope it makes it before 2.6.23, as it is a serious regression.
> > 
> > Do you have the patch that fixes it? If not, please let me know and I'll send it to you.
> 
> No, I don't have it in my hand.  Please sent it to me. Thank you.

Okay, I confirm that current tree does not have this issue
any longer.  Thank you!

--yoshfuji
