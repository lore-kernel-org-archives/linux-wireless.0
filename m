Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44458 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab1AaSnH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:43:07 -0500
Subject: Re: Missing config_hw() in ieee80211_ibss_join?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4D46FF7E.9080409@candelatech.com>
References: <4D46FF7E.9080409@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 19:43:05 +0100
Message-ID: <1296499385.3812.40.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-31 at 10:29 -0800, Ben Greear wrote:
> The method ieee80211_ibss_join can change the operating channel,
> but I don't see anywhere that it calls config_hw to flush the
> changes into the kernel.
> 
> Should we add such a call?

I don't think so -- it doesn't actually really join until it has scanned
first etc.?

johannes

