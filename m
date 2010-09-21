Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38618
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755912Ab0IUTZm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 15:25:42 -0400
Date: Tue, 21 Sep 2010 12:26:02 -0700 (PDT)
Message-Id: <20100921.122602.226770816.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-09-21
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100921182620.GB2448@tuxdriver.com>
References: <20100921182620.GB2448@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 21 Sep 2010 14:26:20 -0400

> Dave,
> 
> Here are two more small fixes intended for 2.6.36.  One is a one-liner
> (kmalloc->kzalloc) that prevents a potential information leak.
> The other is a small fix that skips firmware reloads (a workaround
> for firmware problems) while a scan is in progress in order to avoid
> the stack trace cited in the commit log.
> 
> Please let me know if there are problems!

Pulled, thanks a lot John.
