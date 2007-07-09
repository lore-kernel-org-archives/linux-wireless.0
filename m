Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp156.iad.emailsrvr.com ([207.97.245.156]:38422 "EHLO
	smtp156.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083AbXGIAmE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2007 20:42:04 -0400
Message-ID: <46918403.8080705@gentoo.org>
Date: Sun, 08 Jul 2007 20:40:35 -0400
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Michael Buesch <mb@bu3sch.de>, Ulrich Kunitz <kune@deine-taler.de>,
	Andy Green <andy@warmcat.com>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: Arrested Development
References: <468DE699.9040708@warmcat.com> <46910F3F.8010201@warmcat.com>	 <20070708181524.GA12389@deine-taler.de>  <200707082018.23045.mb@bu3sch.de> <1183921731.3771.2.camel@johannes.berg>
In-Reply-To: <1183921731.3771.2.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sun, 2007-07-08 at 20:18 +0200, Michael Buesch wrote:
> 
>> I think it's the NULL pointer dereference of the mac address pointer,
>> if there's only a monitor interface. The address pointer can be NULL.
> 
> Ahem. I copied a whole bunch of people when I audited that and never got
> a reply (except from you)

I did see the mail when you sent it, thanks. I am recording these issues 
here:

http://www.linuxwireless.org/en/users/Drivers/zd1211rw/mac80211Issues

As you can see, we have a number of things to be looking at, so 
apologies if we are little slow.

Daniel
