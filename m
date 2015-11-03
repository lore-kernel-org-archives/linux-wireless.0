Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:45243 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486AbbKCQer (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 11:34:47 -0500
Date: Tue, 03 Nov 2015 11:34:42 -0500 (EST)
Message-Id: <20151103.113442.1894706546987902519.davem@davemloft.net> (sfid-20151103_173459_821914_EF28E3F9)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull-request: mac80211 2015-11-03
From: David Miller <davem@davemloft.net>
In-Reply-To: <1446561602.29010.23.camel@sipsolutions.net>
References: <1446561602.29010.23.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 03 Nov 2015 15:40:02 +0100

> After the travel I got a whole bunch of things in - I've sorted through
> and taken the fix-like things.
> 
> Note that this is in the mac80211 tree, but based on net-next, since I
> thought you might decide to pull this in before you send a pull request
> to Linus.
> However, the content is only things I'd also send after -rc1 (with the
> WMM stuff being a bit borderline, since it's fairly big, but it's a
> huge improvement with broken APs and we've had it in our Intel tree
> testing there for quite a while.)
> 
> Let me know if you run into any problems.

Pulled, thanks Johannes.
