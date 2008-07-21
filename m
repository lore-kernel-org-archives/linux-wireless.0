Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47630
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750917AbYGUQpZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 12:45:25 -0400
Date: Mon, 21 Jul 2008 09:45:24 -0700 (PDT)
Message-Id: <20080721.094524.152820749.davem@davemloft.net> (sfid-20080721_184528_722848_5A026ED4)
To: hadi@cyberus.ca
Cc: kaber@trash.net, netdev@vger.kernel.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in
 RCU.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1216639201.4847.217.camel@localhost>
References: <20080720.165911.86437240.davem@davemloft.net>
	<1216606839.4847.159.camel@localhost>
	<1216639201.4847.217.camel@localhost>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: jamal <hadi@cyberus.ca>
Date: Mon, 21 Jul 2008 07:20:01 -0400

> Actually, can i modify that thought and go back to my initial contention
> now that things are making more sense?;->
> A single s/ware queue per hardware transmit queue is good - but that
> being pfifo_fast would be a lot better. It would, in the minimal, keep
> things as they were for non-multiq and is a sane choice for any virtual
> wire.

Ok, I'll revert the change that changed pfifo_fast into plain fifo_fast.

Thanks.
