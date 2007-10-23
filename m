Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40751
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752935AbXJWHQr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2007 03:16:47 -0400
Date: Tue, 23 Oct 2007 00:17:10 -0700 (PDT)
Message-Id: <20071023.001710.75190644.davem@davemloft.net> (sfid-20071023_081650_069588_A77A19FE)
To: hs4233@mail.mn-solutions.de
Cc: linux-wireless@vger.kernel.org, drzeus@drzeus.cx, dcbw@redhat.com
Subject: Re: [PATCH] libertas: make if_sdio align packets
From: David Miller <davem@davemloft.net>
In-Reply-To: <200710230858.00343.hs4233@mail.mn-solutions.de>
References: <20071022190532.5077ce3d@poseidon.drzeus.cx>
	<20071022.181530.28790082.davem@davemloft.net>
	<200710230858.00343.hs4233@mail.mn-solutions.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Holger Schurig <hs4233@mail.mn-solutions.de>
Date: Tue, 23 Oct 2007 08:57:59 +0200

> I have been I a similar situation when I wrote if_cs.c. I had 
> virtually no clue about SKBs and how to work with them. I've 
> looked at lwn.net, LDD, googled around, and looked at the 
> in-kernel documentation, which went into fine detail.

On, of all places, http://linux-net.osdl.org/ (which now redirects to
http://www.linux-foundation.org/en/Net) you'll find, of all things, a
link to a document about how SKBs work:

	http://vger.kernel.org/~davem/skb.html

Amazing!  There are even diagrams and figures!!!
