Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44995
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752679AbYG2Uti (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 16:49:38 -0400
Date: Tue, 29 Jul 2008 13:49:35 -0700 (PDT)
Message-Id: <20080729.134935.89985643.davem@davemloft.net> (sfid-20080729_224942_834298_412FA18B)
To: Larry.Finger@lwfinger.net
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	torvalds@linux-foundation.org
Subject: Re: [PATCH] mac80211: partially fix skb->cb use
From: David Miller <davem@davemloft.net>
In-Reply-To: <488F2D64.902@lwfinger.net>
References: <1217323927.10489.9.camel@johannes.berg>
	<488F2D64.902@lwfinger.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Tue, 29 Jul 2008 09:47:00 -0500

> I'm pretty discouraged that a change that has such an impact on wireless never 
> made it to wireless-testing, where this kind of defect should have been found 
> and fixed long before it ever got into mainline.

Considering the fact that all of the wireless folks were having their
wireless summit in Ottawa when all of this was going on, I highly
doubt it would have made one ounce of difference.

That's the only reason this took so long to resolve.
