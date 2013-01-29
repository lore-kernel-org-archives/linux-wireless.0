Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47818 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3A2VzN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 16:55:13 -0500
Message-ID: <1359496537.8108.23.camel@jlt4.sipsolutions.net> (sfid-20130129_225516_486397_C69FD043)
Subject: Re: WARNING: at net/mac80211/agg-tx.c:625  (3.7.5)
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 29 Jan 2013 22:55:37 +0100
In-Reply-To: <51084415.9060409@candelatech.com>
References: <510842C4.3040608@candelatech.com>
	  (sfid-20130129_224440_836761_5DE244B3) <1359496013.8108.22.camel@jlt4.sipsolutions.net>
	 <51084415.9060409@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-01-29 at 13:50 -0800, Ben Greear wrote:
> On 01/29/2013 01:46 PM, Johannes Berg wrote:
> > On Tue, 2013-01-29 at 13:44 -0800, Ben Greear wrote:
> >> This is in 3.7.5, plus one ath9k patch to over-ride eeprom regdomain.
> >>
> >> Code that causes this is here...I seem to have a good test case for
> >> this currently, so if there is any other debugging I could put here
> >> that would be useful, let me know.
> >>
> >> 	if (WARN_ON(!tid_tx)) {
> >> 		ht_dbg(sdata, "addBA was not requested!\n");
> >> 		goto unlock;
> >> 	}
> >
> > Heh, I think Kalle just had the same. Do you have the ht_dbg()
> > statements (i.e. HT debugging) enabled?
> 
> No, it seems I do not.
> 
> Want me to enable it?

Please. Actually, if you can (and it applies) this patch would be
helpful too:
http://git.kernel.org/?p=linux/kernel/git/jberg/mac80211-next.git;a=commit;h=0a214d3f7e5041685ebff054628a4354bedd78c3

johannes

