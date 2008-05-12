Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47364
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755392AbYELJKT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 05:10:19 -0400
Date: Mon, 12 May 2008 02:10:13 -0700 (PDT)
Message-Id: <20080512.021013.255460150.davem@davemloft.net> (sfid-20080512_111022_170617_3686E642)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFT/C 4/7] mac80211: let drivers wake but not start queues
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080510221907.428400000@sipsolutions.net>
References: <20080510221845.340428000@sipsolutions.net>
	<20080510221907.428400000@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Sun, 11 May 2008 00:18:49 +0200

> Having drivers start queues is just confusing, their ->start()
> callback can block and do whatever is necessary, so let mac80211
> start queues and have drivers wake queues when necessary (to get
> packets flowing again right away.)
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Acked-by: David S. Miller <davem@davemloft.net>
