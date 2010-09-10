Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53423 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab0IJV1D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 17:27:03 -0400
To: Ben Greear <greearb@candelatech.com>
Subject: Re: RFC:  v3: Support multiple STA on same AP with ath9k
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date: Fri, 10 Sep 2010 23:27:01 +0200
From: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
In-Reply-To: <4C8AA1C5.8080906@candelatech.com>
References: <4C8A8FF8.4030900@candelatech.com> <fc41890c0792e7440941448d5b8b9169@localhost> <4C8AA1C5.8080906@candelatech.com>
Message-ID: <c358124867aecc372764a1a7c56a3890@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 10 Sep 2010 14:23:17 -0700, Ben Greear <greearb@candelatech.com>
wrote:
> As for counting, as far as I can tell, ath9k doesn't keep a list of
> interfaces, but rather calls those iterator methods when it wants to
> know them, so one way or another I need to call back into mac80211.

But it can just call the atomic iterator with a callback that
keeps the count.

> I'll break the patches apart for the next posting.
> 
> Did you get a chance to think more about this part of the patch?

No, I didn't, and since I'm at the wireless summit now it
seems unlikely that I'll get to it before I get/go back
home on Monday (US time morning).

johannes
