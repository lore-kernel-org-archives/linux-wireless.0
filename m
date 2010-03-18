Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35754 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab0CRFTy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 01:19:54 -0400
Subject: Re: [RFC PATCHv3 1/1] mac80211: Add support connection monitor in
 hardware
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1268888800.10120.646.camel@wimaxnb.nmp.nokia.com>
References: <1268830377-3450-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1268830377-3450-2-git-send-email-juuso.oikarinen@nokia.com>
	 <1268842503.5989.14.camel@jlt3.sipsolutions.net>
	 <1268888800.10120.646.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 22:19:24 -0700
Message-ID: <1268889564.5122.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-03-18 at 07:06 +0200, Juuso Oikarinen wrote:

> We actually had a debate about this with Luciano Coelho, and I opted for
> a separate API, and Luca opted for just adding a flag to the existing
> beacon loss function. To be noted: Luca, two against one now! ;)

:P

> So I'll be sending v4 soon, with a separate API. Worrisomely, the amount
> of comments seems to increase on every round :D

Heh. Well I think I reached the limit of comments for a single patch ;)
But yeah, sorry about that. Sometimes I just don't think about things in
too much detail when there are other things that distract me I guess.

Mind you, the API I proposed requires changing the prototype. If you
don't do the warn_on, which I guess is fine, then you don't have to
change the prototype ... and in any cas eI think I'm off to bed now,
even if that's not really related :)

johannes

