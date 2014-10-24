Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35030 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbaJXUcs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 16:32:48 -0400
Message-ID: <1414182764.2326.11.camel@jlt4.sipsolutions.net> (sfid-20141024_223251_747285_81BD204E)
Subject: Re: Question phy capabilities in 'iw'
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 24 Oct 2014 22:32:44 +0200
In-Reply-To: <544A8171.3000607@candelatech.com> (sfid-20141024_184229_839199_53471630)
References: <544A8171.3000607@candelatech.com>
	 (sfid-20141024_184229_839199_53471630)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-10-24 at 09:42 -0700, Ben Greear wrote:
> Here is the capabilities list from an mac80211_hwsim driver.
> 
> I am curious what information this is actually trying to convey.
> 
> For instance, why is AP in two different places, with different
> values (2048 in first section, 8 in second) ?
> 
> 	valid interface combinations:
> 		 * #{ IBSS } <= 1, #{ managed, AP, mesh point, P2P-client, P2P-GO } <= 2048,
> 		   total <= 2048, #channels <= 1
> 		 * #{ AP } <= 8,
> 		   total <= 8, #channels <= 1, radar detect widths: { 20 MHz (no HT), 20 MHz, 40 MHz, 80 MHz, 160 MHz }

That was probably just a copy-paste error -- check the commit that
introduced it, I'm guessing it came from ath10k or so.

johannes

