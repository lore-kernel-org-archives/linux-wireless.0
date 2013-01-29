Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47796 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3A2Vqg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 16:46:36 -0500
Message-ID: <1359496013.8108.22.camel@jlt4.sipsolutions.net> (sfid-20130129_224638_974298_32A607BC)
Subject: Re: WARNING: at net/mac80211/agg-tx.c:625  (3.7.5)
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 29 Jan 2013 22:46:53 +0100
In-Reply-To: <510842C4.3040608@candelatech.com> (sfid-20130129_224440_836761_5DE244B3)
References: <510842C4.3040608@candelatech.com>
	 (sfid-20130129_224440_836761_5DE244B3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-01-29 at 13:44 -0800, Ben Greear wrote:
> This is in 3.7.5, plus one ath9k patch to over-ride eeprom regdomain.
> 
> Code that causes this is here...I seem to have a good test case for
> this currently, so if there is any other debugging I could put here
> that would be useful, let me know.
> 
> 	if (WARN_ON(!tid_tx)) {
> 		ht_dbg(sdata, "addBA was not requested!\n");
> 		goto unlock;
> 	}

Heh, I think Kalle just had the same. Do you have the ht_dbg()
statements (i.e. HT debugging) enabled?

johannes

