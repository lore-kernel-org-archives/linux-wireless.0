Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38382 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159Ab2FZS4j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 14:56:39 -0400
Message-ID: <1340736988.4484.19.camel@jlt3.sipsolutions.net> (sfid-20120626_205646_237584_29990D0E)
Subject: Re: Help tracing NL80211_CMD_AUTHENTICATE as event in IBSS mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: Will Hawkins <hawkinsw@opentechinstitute.org>,
	Will Hawkins <hawkinsw@opentechinitiative.org>,
	linux-wireless@vger.kernel.org
Date: Tue, 26 Jun 2012 20:56:28 +0200
In-Reply-To: <20120626185533.GA7932@ritirata.org>
References: <24f-4fe93400-17-239c5900@2266046>
	 <1340693584.4662.3.camel@jlt3.sipsolutions.net>
	 <4FE9E201.1010903@opentechinstitute.org>
	 <1340728873.4484.6.camel@jlt3.sipsolutions.net>
	 <4FE9E6F0.2070909@opentechinstitute.org>
	 <1340730210.4484.11.camel@jlt3.sipsolutions.net>
	 <20120626185533.GA7932@ritirata.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-26 at 20:55 +0200, Antonio Quartulli wrote:

> @johannes: de-duplication? IBSS/RSN assumes that each node runs an authenticator
> and a supplicant. Does this mean that we need exactly two 4-way handshakes? Why
> should we have a "winner"?

I may misremember, I thought we didn't need two handshakes. But maybe we
do, and just throw away one of the PTKs?

johannes

