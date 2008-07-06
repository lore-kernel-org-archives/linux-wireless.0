Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:28241 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458AbYGFNpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2008 09:45:13 -0400
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFT 1/4] mac80211: make master netdev handling sane
References: <20080705234735.210585000@sipsolutions.net>
	<20080705235012.501072000@sipsolutions.net>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sun, 06 Jul 2008 16:44:59 +0300
In-Reply-To: <20080705235012.501072000@sipsolutions.net> (ext Johannes Berg's message of "Sun\, 06 Jul 2008 01\:47\:36 +0200")
Message-ID: <87tzf3p1no.fsf@nokia.com> (sfid-20080706_154532_275028_59816DB7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> ******
> ** Please test!
> **
> ** I have not tested this patch heavily yet, especially not
> ** in anything other than STA mode. I believe it should work
> ** with the possible exception of power saving in IBSS, but
> ** I don't think we handle that anyway because we don't do
> ** anything about ATIM windows etc.
> ******

Are there any devices on the market which properly support PSM in
Ad-Hoc mode? At least N800/N810 don't support it. 

I have heard that the standard is quite unclear regarding this. And,
after seeing the countless ways APs have managed to break PSM in
infrastructure mode, I can only imagine what kind of interoperability
problems there are with PSM in Ad-Hoc mode :)

So I think we should forget PSM in Ad-Hoc mode, at least for now.

-- 
Kalle Valo
