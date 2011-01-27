Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58510 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab1A0Nek (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 08:34:40 -0500
Subject: Re: Question on power-save
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4D40C122.9020402@candelatech.com>
References: <4D40C122.9020402@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Jan 2011 14:34:38 +0100
Message-ID: <1296135278.3622.38.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-26 at 16:49 -0800, Ben Greear wrote:
> I was looking at this ps_enable method:
> 
> static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)

If you read the comment in front of the function, is it clearer?

Yes, it disables PS locally, but it tells the AP we've gone to PS.

johannes

