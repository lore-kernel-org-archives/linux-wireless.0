Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51666
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753124AbYGQNMj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 09:12:39 -0400
Date: Thu, 17 Jul 2008 06:12:39 -0700 (PDT)
Message-Id: <20080717.061239.51839567.davem@davemloft.net> (sfid-20080717_151244_384123_99CF5BF2)
To: kaber@trash.net
Cc: netdev@vger.kernel.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in
 RCU.
From: David Miller <davem@davemloft.net>
In-Reply-To: <487F4327.1000107@trash.net>
References: <20080717.051726.226040470.davem@davemloft.net>
	<487F4327.1000107@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 17 Jul 2008 15:03:35 +0200

> Still working my way through the patches, but this one caught my
> eye (we had this before and it caused quite a few problems).

Indeed, it's the most delicate change.

Thanks for the info about all the tricky bits in this area.
