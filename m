Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47063
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750878AbYGREaI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 00:30:08 -0400
Date: Thu, 17 Jul 2008 21:30:07 -0700 (PDT)
Message-Id: <20080717.213007.193697961.davem@davemloft.net> (sfid-20080718_063020_482078_148287C6)
To: netdev@vger.kernel.org
Cc: kaber@trash.net, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/31]: Final set of TX multiqueue changes.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080717.051526.193688049.davem@davemloft.net>
References: <20080717.051526.193688049.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Miller <davem@davemloft.net>
Date: Thu, 17 Jul 2008 05:15:26 -0700 (PDT)

> Unless I hear a huge objection, I intend to pull this work into
> net-next-2.6 tomorrow so I can toss it all to Linus this coming
> Sunday.

I've just pushed net-tx-2.6 into net-next-2.6, as all the problems
brought up are fixable and there are very clear plans on how
to address all of them.
