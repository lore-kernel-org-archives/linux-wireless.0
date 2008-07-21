Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:13467 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbYGUN43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 09:56:29 -0400
Received: by py-out-1112.google.com with SMTP id p76so1050805pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2008 06:56:28 -0700 (PDT)
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction
	in	RCU.
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: davem@davemloft.net, kaber@trash.net, netdev@vger.kernel.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
In-Reply-To: <20080721131918.GA11114@gondor.apana.org.au>
References: <E1KKu2D-0002kd-00@gondolin.me.apana.org.au>
	 <1216645724.4847.275.camel@localhost>
	 <20080721131918.GA11114@gondor.apana.org.au>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 09:56:25 -0400
Message-Id: <1216648585.4847.303.camel@localhost> (sfid-20080721_155637_514456_7C286807)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-21-07 at 21:19 +0800, Herbert Xu wrote:

> It should work just fine for routing assuming your card does
> multi-queue RX.

Ok - You may be able to pull it if you have the exact same hashing on
hardware rx as it is on transmit stateless filtering.
I can see a traffic pattern that could be cooked to give some good
numbers in such a scenario;->

cheers,
jamal

