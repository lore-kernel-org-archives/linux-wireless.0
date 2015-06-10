Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60330 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbbFJVtP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 17:49:15 -0400
Message-ID: <1433972952.3145.19.camel@sipsolutions.net> (sfid-20150610_234918_008953_13133EBB)
Subject: Re: Add netdev name to  NL80211_CMD_STOP_AP event?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 10 Jun 2015 23:49:12 +0200
In-Reply-To: <5578AF90.5030609@candelatech.com>
References: <5578AA11.2020505@candelatech.com>
	  (sfid-20150610_232022_833916_9A1896A2) <1433972365.3145.18.camel@sipsolutions.net>
	 <5578AF90.5030609@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-10 at 14:43 -0700, Ben Greear wrote:

> I was thinking netdevice might go away before user-space can decode the
> message ( I was assuming that on delete you would stop and very shortly
> after that delete the netdev).

Yeah, but in that case ... does it matter? :)

> It's a small patch to iw and the kernel as far as I can tell...

It's small *now*, but if we add it to all events it'll end up pretty
big...

johannes

