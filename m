Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50520
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753774AbYCTWKi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2008 18:10:38 -0400
Date: Thu, 20 Mar 2008 15:10:54 -0700 (PDT)
Message-Id: <20080320.151054.41532763.davem@davemloft.net> (sfid-20080320_221042_909507_907574BA)
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, sam@ravnborg.org, dsd@gentoo.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH/RFC v2] introduce ARCH_CAN_UNALIGNED_ACCESS Kconfig
 symbol
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080320220348.GC1330@tuxdriver.com>
References: <20080320.141307.173590705.davem@davemloft.net>
	<1206048106.16475.161.camel@johannes.berg>
	<20080320220348.GC1330@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 20 Mar 2008 18:03:48 -0400

> While I think Dave has a point, I don't think you should labor the word
> choice too much.  Try to document it as clearly as possible and hope
> for the best -- I hear that the arch maintainers are top notch! :-)

I think the name of the macro is very important.

Non-arch people will see this thing and wonder what in the
world it means.  You can document something with kerneldoc
foo as much as you like, still the initial impression the
reader gets from the name is of utmost importance.
