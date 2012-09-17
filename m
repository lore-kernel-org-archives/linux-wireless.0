Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36754 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab2IQPRI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2012 11:17:08 -0400
Message-ID: <1347895064.4975.7.camel@jlt4.sipsolutions.net> (sfid-20120917_171713_380441_698CBF65)
Subject: Re: regression: tethering fails in 3.5 with iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Eric Dumazet <edumazet@google.com>
Cc: artem.bityutskiy@linux.intel.com, linux-wireless@vger.kernel.org
Date: Mon, 17 Sep 2012 17:17:44 +0200
In-Reply-To: <CANn89iJymkq8LKcNCFCbQakfEZ+zV4Nbg33wATBD7oc0QCnj6Q@mail.gmail.com> (sfid-20120917_171545_758986_2167CDC2)
References: <1347361823.26457.3.camel@sauron.fi.intel.com>
	 <1DC40B07CD6EC041A66726C271A73AE6195AE9C8@IRSMSX102.ger.corp.intel.com>
	 <1347631355.5263.19.camel@sauron.fi.intel.com>
	 <1347640763.5263.24.camel@sauron.fi.intel.com>
	 <1347892887.7112.9.camel@sauron.fi.intel.com>
	 <CANn89iJymkq8LKcNCFCbQakfEZ+zV4Nbg33wATBD7oc0QCnj6Q@mail.gmail.com>
	 (sfid-20120917_171545_758986_2167CDC2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-09-17 at 17:15 +0200, Eric Dumazet wrote:
> Hi
> 
> I would say some part of the stack assumes a header (I dont know wich
> one ?) is pulled in skb->head/data, and thats a bug.
> 
> Always use pskb_may_pull(skb, XXX) to make sure you can access XXX
> bytes in skb->data
> 
> It would help if you describe the problem, because I have no history (
> I am not linux-wireless subscriber).

No worries, I'll take care of it, I've just not gotten to it yet and for
that I apologize. I'll either look at it later today or tomorrow.

johannes

