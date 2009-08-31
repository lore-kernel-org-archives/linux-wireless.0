Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1746 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbZHaMyq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 08:54:46 -0400
Date: Mon, 31 Aug 2009 08:53:12 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>, proski@gnu.org,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	ic.felix@gmail.com, Felix Fietkau <nbd@openwrt.org>
Subject: Re: Ath5k and proprietary extensions
Message-ID: <20090831125312.GB11006@hash.localnet>
References: <40f31dec0908282151t245912f0ye79684d4a519f3c9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0908282151t245912f0ye79684d4a519f3c9@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 29, 2009 at 07:51:29AM +0300, Nick Kossifidis wrote:
> Most code is there for half/quarter and (static) turbo operation, we
> just have to deal with pll programming, clock settings etc. Question
> is how do we use it, NL80211_CMD_TESTMODE is an option i guess and in
> case no one else thinks that we could use a channel width API (or
> extend what we have) for setting 5/10/40MHz width through cfg80211, we
> can just stick to NL80211_CMD_TESTMODE.

Well, we will have a channel width API, I think; several people
have expresed an interest in doing so.

Your summary is useful, and I really don't have any qualms about
keeping the non-standard stuff as long as someone has plans to
write the code to support it.  I personally have no interest
in using those features, but of course I only speak for me.

If we do remove turbo code for now, we can leave the initvals, as
they are such a pain to verify.  But I'm not sure half a page of
text is worth the churn.

-- 
Bob Copeland %% www.bobcopeland.com

