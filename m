Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48669 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759395Ab0ECN5p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 09:57:45 -0400
Subject: Re: [PATCH] mac80211: improve IBSS scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20100503T154149-617@post.gmane.org>
References: <469051.90774.qm@web51402.mail.re2.yahoo.com>
	 <1272893084.3614.37.camel@jlt3.sipsolutions.net>
	 <loom.20100503T153803-630@post.gmane.org>
	 <loom.20100503T154149-617@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 15:57:42 +0200
Message-ID: <1272895062.3614.39.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-05-03 at 13:43 +0000, Joerg Pommnitz wrote:
> Johannes Berg <johannes@...> writes:
> > Hidden SSID is a hack (which doesn't work with IBSS obviously), but this
> > kinda seems worse.
>  
> Actually, it does (work on IBSS, that is). And because I thought what you think
> I have the
> radiotap traces to prove it. 

Interesting. I guess we never rejected it although it's invalid
according to the standard. Yuck. I think I would like to make nl80211
reject it, but maybe I'll forget about it and let you use it ;)

johannes

