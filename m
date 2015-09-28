Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37789 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932620AbbI1Mhf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2015 08:37:35 -0400
Message-ID: <1443443851.2401.6.camel@sipsolutions.net> (sfid-20150928_143738_878946_8C7B66BE)
Subject: Re: Low latency communication over wifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Bastian Bittorf <bittorf@bluebottle.com>
Cc: Pavel Machek <pavel@ucw.cz>, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@do-not-panic.com,
	linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Date: Mon, 28 Sep 2015 14:37:31 +0200
In-Reply-To: <20150928121504.GE22537@medion.lan>
References: <20150926102403.GA21555@amd>
	 <1443426103.2401.1.camel@sipsolutions.net>
	 <20150928121504.GE22537@medion.lan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-09-28 at 14:15 +0200, Bastian Bittorf wrote:
> * Johannes Berg <johannes@sipsolutions.net> [28.09.2015 14:00]:
> > > > # you have to add some magic for matching your data
> > > > e.g. $IPT -t mangle -I OUTPUT -j DSCP --set-dscp-class CS7
> > > 
> > > Again, this is ping -Q equivalent, right? I was doing
> > 
> > Yes.
> 
> IMHO this is not the same: you have to do it on both ends.
> (also the iptables thingy)
> 

Depends what you're measuring, but ping should apply the same DSCP tag
on the response I believe.

johannes
