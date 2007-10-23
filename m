Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:21191 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbXJWG6G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2007 02:58:06 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: make if_sdio align packets
Date: Tue, 23 Oct 2007 08:57:59 +0200
Cc: David Miller <davem@davemloft.net>, drzeus@drzeus.cx,
	dcbw@redhat.com
References: <20071022190532.5077ce3d@poseidon.drzeus.cx> <20071022.181530.28790082.davem@davemloft.net>
In-Reply-To: <20071022.181530.28790082.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710230858.00343.hs4233@mail.mn-solutions.de> (sfid-20071023_075814_842200_7FF584E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David !

I have been I a similar situation when I wrote if_cs.c. I had 
virtually no clue about SKBs and how to work with them. I've 
looked at lwn.net, LDD, googled around, and looked at the 
in-kernel documentation, which went into fine detail. But I 
failed to grasp the real picture, e.g. up until now I don't have 
any idea why there are so many different functions to modify 
skb's in subtle ways.

So one can say that I still have virtually no clue about SKBs. 
That if_cs.c works, might even be coincididence, thanks to 
try-and-error. :-)

I've not seen if_sdio.c yet, but if Pierre looked at my if_cs.c 
when surely he started from my incomplete view of things :-(
