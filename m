Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43209 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbcFKH6a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jun 2016 03:58:30 -0400
Message-ID: <1465631903.2827.0.camel@sipsolutions.net> (sfid-20160611_095928_688154_5C1F511F)
Subject: Re: pull-request: mac80211-next 2016-06-09
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Sat, 11 Jun 2016 09:58:23 +0200
In-Reply-To: <20160610.231604.604019579709781335.davem@davemloft.net>
References: <1465477466-23756-1-git-send-email-johannes@sipsolutions.net>
	 <20160610.231604.604019579709781335.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-06-10 at 23:16 -0700, David Miller wrote:

> > Can I ask you to pull net into net-next, preferably before merging
> > this?

> Looks good, pulled, thanks!

Thanks! I see you also had pulled net in for other reasons, so I'll
include the hwsim namespace patch in the next pull request :)

johannes
