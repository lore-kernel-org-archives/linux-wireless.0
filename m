Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37096
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752690AbXIZFib (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 01:38:31 -0400
Date: Tue, 25 Sep 2007 22:38:31 -0700 (PDT)
Message-Id: <20070925.223831.66158385.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: Please pull 'upstream-davem' branch of wireless-2.6 (for  2.6.24)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070922195457.GA22629@tuxdriver.com>
References: <20070922195457.GA22629@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Sat, 22 Sep 2007 15:54:57 -0400

> The individual patches are available here:
> 
> 	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/upstream-davem/

I sucked these into my net-2.6.24 tree, thanks John.

It may look slightly different because I applied the iwlwifi
CFLAGS Makefile patch directly from Intel and I did the
iwlwifi directory source move on my own.

Thanks!
