Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40362 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbcFJVIz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2016 17:08:55 -0400
Message-ID: <1465592932.2308.6.camel@sipsolutions.net> (sfid-20160610_230858_966627_F0F24D67)
Subject: Re: NL80211_ATTR_PAD question
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 10 Jun 2016 23:08:52 +0200
In-Reply-To: <575B1964.2030806@candelatech.com> (sfid-20160610_214753_670799_49B46ECD)
References: <575B1964.2030806@candelatech.com>
	 (sfid-20160610_214753_670799_49B46ECD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-06-10 at 12:47 -0700, Ben Greear wrote:
> I see this was added sometime recently:  NL80211_ATTR_PAD
> 
> If another enum member is added, should it replace the PAD enum?

No.

> At the least, I think we need some comments about how this is to be
> dealt with.
> 

You simply ignore it :)

johannes
