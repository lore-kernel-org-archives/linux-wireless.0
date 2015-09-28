Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bluebottle.com ([176.9.67.91]:56659 "EHLO
	mail.bluebottle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108AbbI1MQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2015 08:16:11 -0400
Date: Mon, 28 Sep 2015 14:15:04 +0200
From: Bastian Bittorf <bittorf@bluebottle.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Pavel Machek <pavel@ucw.cz>, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@do-not-panic.com,
	linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Subject: Re: Low latency communication over wifi
Message-ID: <20150928121504.GE22537@medion.lan> (sfid-20150928_141615_160759_648F3D84)
References: <20150926102403.GA21555@amd>
 <1443426103.2401.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443426103.2401.1.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Johannes Berg <johannes@sipsolutions.net> [28.09.2015 14:00]:
> > > # you have to add some magic for matching your data
> > > e.g. $IPT -t mangle -I OUTPUT -j DSCP --set-dscp-class CS7
> > 
> > Again, this is ping -Q equivalent, right? I was doing
> 
> Yes.

IMHO this is not the same: you have to do it on both ends.
(also the iptables thingy)

bye, bastian
