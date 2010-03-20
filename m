Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47214 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab0CTUk2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Mar 2010 16:40:28 -0400
Subject: Re: [PATCH V2] mac80211: Revise,pending queue depth in
 ieee80211_local data structure
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: randolf.bruno@googlemail.com, linux-wireless@vger.kernel.org
In-Reply-To: <f74418681003201302g3ed2902bp230a1ce93d165831@mail.gmail.com>
References: <4BA24A12.4030208@gmail.com>
	 <a0b9368788449213d36b75dccd97c6a6@localhost>
	 <201003201144.24471.randolf.bruno@gmail.com>
	 <201003201207.11218.randolf.bruno@gmail.com>
	 <f74418681003201302g3ed2902bp230a1ce93d165831@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Mar 2010 13:40:05 -0700
Message-ID: <1269117605.4611.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-03-20 at 21:02 +0100, Lorenzo Bianconi wrote:

> >> setup 2 wireless cards, talking to each other (i use IBSS) on different
> >> machines. then setup routing like this:


> PC1<--ethernet cable-->Device1<--wireless link-->Device2<--ethernet cable-->PC2

I'm not really sure how this scenario differs from injecting traffic
locally, but I'll try to reproduce.

johannes

