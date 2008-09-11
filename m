Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53531
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752239AbYIKWhu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 18:37:50 -0400
Date: Thu, 11 Sep 2008 15:37:43 -0700 (PDT)
Message-Id: <20080911.153743.113096478.davem@davemloft.net> (sfid-20080912_003753_158036_1D1DA5A1)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-09-11
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080911201308.GJ3423@tuxdriver.com>
References: <20080911201308.GJ3423@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 11 Sep 2008 16:13:09 -0400

> Here is one fix for 2.6.27.  It is a backport of a patch that is already
> in net-next-2.6.  Since it is for a new driver (ath9k) and since it
> fixes a reported bug (http://bugzilla.kernel.org/show_bug.cgi?id=11394)
> I think it should be OK to pass it to Linus for the current cycle.

Pulled and pushed back out to net-2.6, thanks John.
