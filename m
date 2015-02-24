Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39774 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbbBXOfE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 09:35:04 -0500
Message-ID: <1424788499.2192.32.camel@sipsolutions.net> (sfid-20150224_153508_665702_1F9BFA6A)
Subject: Re: [PATCH] mac80211-hwsim:  Don't enqueue pkts that do not want
 txstatus.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 24 Feb 2015 15:34:59 +0100
In-Reply-To: <54EC8A74.2080700@candelatech.com>
References: <1423592732-17256-1-git-send-email-greearb@candelatech.com>
		 <1424707739.3075.19.camel@sipsolutions.net>
		 <54EB6589.6040803@candelatech.com>
	 <1424772854.2192.19.camel@sipsolutions.net>
	 <54EC8A74.2080700@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-02-24 at 06:28 -0800, Ben Greear wrote:

> If there is no status to return, then why would user-space call back at all?
> 
> Should user-space *always* return a status even when not requested to?

I'd certainly expect so from hwsim.

johannes

