Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:25031 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbYGULje (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 07:39:34 -0400
Received: by py-out-1112.google.com with SMTP id p76so1000535pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2008 04:39:34 -0700 (PDT)
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in
	RCU.
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: kaber@trash.net, davem@davemloft.net, netdev@vger.kernel.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
In-Reply-To: <20080721113600.GA10322@gondor.apana.org.au>
References: <E1KKZmE-0000ty-00@gondolin.me.apana.org.au>
	 <1216568119.4847.101.camel@localhost>
	 <20080721001119.GA6515@gondor.apana.org.au>
	 <1216607637.4847.172.camel@localhost>
	 <20080721031716.GA7535@gondor.apana.org.au>
	 <1216638879.4847.210.camel@localhost>
	 <20080721113600.GA10322@gondor.apana.org.au>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 07:39:31 -0400
Message-Id: <1216640371.4847.230.camel@localhost> (sfid-20080721_133945_994004_690A8983)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-21-07 at 19:36 +0800, Herbert Xu wrote:

> Sorry, I think I'll have to poke my eyes out :)

But i still need your eyes to poke at my code Herbert;-> 

> But yeah if we ever get a generic dynamic hash table implmenetation
> then I'd be happy for act_nat to use that.

Ok, i have added it to my todo.

cheers,
jamal

