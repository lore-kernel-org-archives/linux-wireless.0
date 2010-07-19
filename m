Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38162
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933436Ab0GSTiv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jul 2010 15:38:51 -0400
Date: Mon, 19 Jul 2010 12:39:07 -0700 (PDT)
Message-Id: <20100719.123907.128579773.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-07-19
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100719191709.GA6115@tuxdriver.com>
References: <20100719191709.GA6115@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 19 Jul 2010 15:17:09 -0400

> In this round we have two more-or-less-one-liners intended for 2.6.25.
> 
> The hostap fix is the third (and hopefully final) bite at the apple
> for correcting an initialization failure.  The first two attempts
> created and then reinstated a regression caused by a discrepency
> between the PCI and PCMCIA support within hostap.  The regression
> was caused by checking the value of dev->base_addr, which the PCI
> code was not setting.  Testing by the regression reporter indicates
> that his device is finally working again with this fix.
> 
> The rt2x00 fix merely reorders some initialization so that unwinding
> that init in an error path works as expected.

Pulled, thanks John.
