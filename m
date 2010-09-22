Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43882
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755752Ab0IVBfz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 21:35:55 -0400
Date: Tue, 21 Sep 2010 18:36:14 -0700 (PDT)
Message-Id: <20100921.183614.245388137.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2010-09-21
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100921201705.GC2448@tuxdriver.com>
References: <20100921201705.GC2448@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 21 Sep 2010 16:17:05 -0400

> I apologize for this being another huge batch of udpates.  FWIW,
> I got a little behind on the merging while at the wireless summit in
> SF a couple of weeks ago.  Anyway, I'll try harder to keep-up!
> 
> This is largely the usual round of (mostly driver) updates.
> Some highlights of this round include the addition of carl9170
> (a community-developed successor to ar9170), some significant code
> refactoring in ath5k to improve maintainability, and some wl1271
> improvements from the guys at TI (including some related OMAP bits
> that have been ACKed by the appropriate arch guys).  Helmut Schaa
> continues to send rt2x00 updates, and the Intel and Atheros teams
> have their usual strong showings as well.
> 
> Please let me know if ther are problems!

Pulled, but I suspect the 'packed' attribute usage is wrong in
ath/carl9170 and can just be deleted.
