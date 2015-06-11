Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35203 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbbFKKBm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 06:01:42 -0400
Message-ID: <1434016900.1915.8.camel@sipsolutions.net> (sfid-20150611_120146_009184_3158A9E9)
Subject: Re: Exposing enum ieee80211_channel_flags to user
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 11 Jun 2015 12:01:40 +0200
In-Reply-To: <CACna6ry_VRbUbEQeVXC5j68VzPOkJ-qOsAGzKN8XswhHXnO+tw@mail.gmail.com> (sfid-20150611_120017_614164_3F327AEA)
References: <CACna6rwHXzGTZ+NS9PpZENJATVzRzm1Wkija0_CrveMoM05d5g@mail.gmail.com>
	 <1434015922.1915.6.camel@sipsolutions.net>
	 <1434016002.1915.7.camel@sipsolutions.net>
	 <CACna6ry_VRbUbEQeVXC5j68VzPOkJ-qOsAGzKN8XswhHXnO+tw@mail.gmail.com>
	 (sfid-20150611_120017_614164_3F327AEA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-06-11 at 12:00 +0200, Rafał Miłecki wrote:

> > Upon rereading, I think my preference would be to remove much of the
> > channel list information and add a separate iw command.
> 
> Do you mean removing channel list from "iw phy X info"? 

I'm not sure I'd remove it completely - but perhaps remove all the
detail information like DFS time etc. that's just making it really
large? I.e. go back to just having a single line of information.

> Can you suggest the new command name?

"iw phy X channels" would work?

johannes

