Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:47726 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761243Ab0GTSyA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 14:54:00 -0400
Date: Tue, 20 Jul 2010 20:53:56 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mwl8k: correct/silence sparse warnings
Message-ID: <20100720185356.GE21121@mail.wantstofly.org>
References: <1279650123.3706.45.camel@jlt3.sipsolutions.net> <1279651154-11985-1-git-send-email-linville@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1279651154-11985-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 20, 2010 at 02:39:14PM -0400, John W. Linville wrote:

> drivers/net/wireless/mwl8k.c:1541:21: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/mwl8k.c:1541:21:    expected restricted __le16 [usertype] result
> drivers/net/wireless/mwl8k.c:1541:21:    got int
> drivers/net/wireless/mwl8k.c:1575:42:    expected unsigned short [unsigned] [usertype] cmd
> drivers/net/wireless/mwl8k.c:1575:42:    got restricted __le16 [usertype] code
> drivers/net/wireless/mwl8k.c:1587:50: warning: incorrect type in argument 1 (different base types)
> drivers/net/wireless/mwl8k.c:1587:50:    expected unsigned short [unsigned] [usertype] cmd
> drivers/net/wireless/mwl8k.c:1587:50:    got restricted __le16 [usertype] code
> drivers/net/wireless/mwl8k.c:1592:50: warning: incorrect type in argument 1 (different base types)
> drivers/net/wireless/mwl8k.c:1592:50:    expected unsigned short [unsigned] [usertype] cmd
> drivers/net/wireless/mwl8k.c:1592:50:    got restricted __le16 [usertype] code
> drivers/net/wireless/mwl8k.c:1845:27: warning: incorrect type in argument 1 (different base types)
> drivers/net/wireless/mwl8k.c:1845:27:    expected unsigned int [unsigned] [usertype] <noident>
> drivers/net/wireless/mwl8k.c:1845:27:    got restricted __le32 [usertype] <noident>
> drivers/net/wireless/mwl8k.c:1848:27: warning: incorrect type in argument 1 (different base types)
> drivers/net/wireless/mwl8k.c:1848:27:    expected unsigned int [unsigned] [usertype] <noident>
> drivers/net/wireless/mwl8k.c:1848:27:    got restricted __le32 [usertype] <noident>
> drivers/net/wireless/mwl8k.c:1851:27: warning: incorrect type in argument 1 (different base types)
> drivers/net/wireless/mwl8k.c:1851:27:    expected unsigned int [unsigned] [usertype] <noident>
> drivers/net/wireless/mwl8k.c:1851:27:    got restricted __le32 [usertype] <noident>
> drivers/net/wireless/mwl8k.c:1854:27: warning: incorrect type in argument 1 (different base types)
> drivers/net/wireless/mwl8k.c:1854:27:    expected unsigned int [unsigned] [usertype] <noident>
> drivers/net/wireless/mwl8k.c:1854:27:    got restricted __le32 [usertype] <noident>
> drivers/net/wireless/mwl8k.c:1857:27: warning: incorrect type in argument 1 (different base types)
> drivers/net/wireless/mwl8k.c:1857:27:    expected unsigned int [unsigned] [usertype] <noident>
> drivers/net/wireless/mwl8k.c:1857:27:    got restricted __le32 [usertype] <noident>
> drivers/net/wireless/mwl8k.c:1860:27: warning: incorrect type in argument 1 (different base types)
> drivers/net/wireless/mwl8k.c:1860:27:    expected unsigned int [unsigned] [usertype] <noident>
> drivers/net/wireless/mwl8k.c:1860:27:    got restricted __le32 [usertype] <noident>
> drivers/net/wireless/mwl8k.c:3055:20: warning: incorrect type in assignment (different base types)
> drivers/net/wireless/mwl8k.c:3055:20:    expected restricted __le16 [usertype] ht_caps
> drivers/net/wireless/mwl8k.c:3055:20:    got unsigned short [unsigned] [usertype] cap
> 
> At least the last one looks like a real bug...
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Looks good!

Acked-by: Lennert Buytenhek <buytenh@wantstofly.org>
