Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:35014 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934756AbdLSJoz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 04:44:55 -0500
Message-ID: <1513676688.26145.7.camel@sipsolutions.net> (sfid-20171219_104459_563705_F15868E0)
Subject: Re: [PATCH v3 1/3] mac80211: Add TXQ scheduling API
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@nbd.name>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Tue, 19 Dec 2017 10:44:48 +0100
In-Reply-To: <78c2f69c-fafa-6270-33b5-fbce57f4a278@nbd.name>
References: <20171027141451.22768-1-toke@toke.dk>
         <20171031112747.5778-1-toke@toke.dk>
         <b2ed2696-db3d-4797-b5e2-161172fd2413@nbd.name> <87lgi5jyka.fsf@toke.dk>
         <78c2f69c-fafa-6270-33b5-fbce57f4a278@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-12-14 at 13:44 +0100, Felix Fietkau wrote:
> 
> First we should revert these patches.

FWIW, I've just done that, if only to make the mt76 merge possible.

> We can respin them shortly after in a modified form where
> ieee80211_next_txq takes a 'queue' argument.

I'll leave the two of you to discuss that :-)

> I'm almost done with the incremental change for that, and it also
> supports passing -1 for queue so incrementally switching to the
> scheduling that you're proposing will also work.

Sounds fine to me.

> With that in place we can replace the ath9k change with a much smaller
> patch that is easier to verify for correctness and won't introduce the
> potential regressions that I pointed out.
> 
> I will take care of the mt76 porting today and I'll also help with
> sorting out the ath10k issues.

So are you going to resend Toke's patches with your adjustments folded
in? Or just one of them?

johannes
