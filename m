Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sycorax.lbl.gov ([128.3.11.121]:40373 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275Ab3C0U3z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 16:29:55 -0400
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Subject: Re: iwlwifi unable to reconnect after suspend since v3.9-rc1
References: <87li993mug.fsf@sycorax.lbl.gov>
	<1364390086.8388.7.camel@jlt4.sipsolutions.net>
	<87r4j021ac.fsf@sycorax.lbl.gov>
	<1364406085.8388.11.camel@jlt4.sipsolutions.net>
	<87ip4cg1qg.fsf@sycorax.lbl.gov>
	<1364410962.8388.19.camel@jlt4.sipsolutions.net>
	<87txnwacdw.fsf@sycorax.lbl.gov>
	<1364411696.8388.21.camel@jlt4.sipsolutions.net>
	<871ub0zlgp.fsf@sycorax.lbl.gov>
	<1364413484.8388.23.camel@jlt4.sipsolutions.net>
	<87k3oszk2g.fsf@sycorax.lbl.gov>
	<1364415196.8388.26.camel@jlt4.sipsolutions.net>
Date: Wed, 27 Mar 2013 13:29:49 -0700
In-Reply-To: <1364415196.8388.26.camel@jlt4.sipsolutions.net> (message from
	Johannes Berg on Wed, 27 Mar 2013 21:13:16 +0100)
Message-ID: <87d2ukziv6.fsf@sycorax.lbl.gov> (sfid-20130327_212959_493828_106A5F72)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Ah so it's even the same packet because we set
> IEEE80211_TX_STAT_TX_FILTERED.
>
> Note the delay here -- roughly between 84.4428 and 84.5328 we wait for a
> beacon.
>
> I'll apply the patch and add your tested-by, like this:
>
> http://p.sipsolutions.net/7e871bfb5a0b272a.txt
>
> OK?

looks good. thanks.

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
