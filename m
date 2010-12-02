Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48236 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab0LBViO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 16:38:14 -0500
Subject: Re: [RFC 5/5 v2] cfg80211/mac80211: add mesh join/leave commands
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless@vger.kernel.org, Steve Derosier <steve@cozybit.com>,
	devel@lists.open80211s.org
In-Reply-To: <AANLkTi=8yikvhvbUS86FZabM5qXbZ1LNHeT+2JQGU+QS@mail.gmail.com>
References: <20101201205939.009530439@sipsolutions.net>
	 <20101201210226.159495600@sipsolutions.net>
	 <1291279510.3481.17.camel@jlt3.sipsolutions.net>
	 <AANLkTik_C90v-313Pq_dPY7fE1OFG2X0uv8Ys+uGQFRt@mail.gmail.com>
	 <1291320849.3481.55.camel@jlt3.sipsolutions.net>
	 <AANLkTi=8yikvhvbUS86FZabM5qXbZ1LNHeT+2JQGU+QS@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 22:38:13 +0100
Message-ID: <1291325893.3481.56.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-02 at 13:24 -0800, Javier Cardona wrote:
> Johannes,
> 
> Thanks for reviewing.  You were right: scanning did stop beaconing
> forever and your suggested fix resolved that.  So the patch is now:

Thanks for that.

> We have not run our full suite but we tested legacy interface mesh up,
> joining, leaving and rejoining different meshes and all seems to work.

Great.

>  Feel free to add my tested-by or signoff tags.

So you're happy with the 1/5 patch as well now?

johannes

