Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43054 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab1FHL0K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 07:26:10 -0400
Subject: Re: sta_find_ibss (active_ibss=1) in a loop?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ignacy Gawedzki <i@lri.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20110608111340.GA25889@zenon.in.qult.net>
References: <20110603201644.GA7836@zenon.in.qult.net>
	 <20110603204939.GA12854@zenon.in.qult.net>
	 <20110606110429.GA18775@zenon.in.qult.net>
	 <1307370716.3894.10.camel@jlt3.sipsolutions.net>
	 <20110606160115.GA31258@zenon.in.qult.net>
	 <1307376692.3894.12.camel@jlt3.sipsolutions.net>
	 <20110608111340.GA25889@zenon.in.qult.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Jun 2011 13:26:09 +0200
Message-ID: <1307532369.3961.10.camel@jlt3.sipsolutions.net> (sfid-20110608_132614_163931_9FC6B3EF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-06-08 at 13:13 +0200, Ignacy Gawedzki wrote:
> On Mon, Jun 06, 2011 at 06:11:32PM +0200, thus spake Johannes Berg:
> > Oh ok. Well, I think we should put these changes in anyway since I see
> > nothing preventing the race now.
> 
> After having applied this patch, I haven't seen the problem appear for two
> days (and two nights) of testing.  I suppose this sort of confirms the fix.

Thanks. I just sent out the patch officially.

johannes

