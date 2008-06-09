Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51541
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761921AbYFIWjP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 18:39:15 -0400
Date: Mon, 09 Jun 2008 15:39:14 -0700 (PDT)
Message-Id: <20080609.153914.154669065.davem@davemloft.net> (sfid-20080610_003927_868994_D1E4206F)
To: linville@tuxdriver.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-06-09
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080609210858.GB15375@tuxdriver.com>
References: <20080609210858.GB15375@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 9 Jun 2008 17:08:58 -0400

> Dave,
> 
> Here is another round of fixes intended for 2.6.26.  Most of them are
> small and obvious.
> 
> The ipw2200 one [1] is big, but a lot of it is moving and/or deleting some
> old code.  It fixes a problem that can cause a new scan request to
> eclipse and existing one in a way that keeps userland from getting the
> requested scan results.
> 
> Please let me know if there are problems!

Pulled and pushed back out to net-2.6, thanks John!
