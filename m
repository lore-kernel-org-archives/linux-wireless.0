Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:53840 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754341AbeEHKSp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 May 2018 06:18:45 -0400
Message-ID: <1525774721.14830.3.camel@sipsolutions.net> (sfid-20180508_121848_731076_29F2602F)
Subject: Re: [PATCH 1/3] cfg80211: Expose TXQ stats and parameters to
 userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Tue, 08 May 2018 12:18:41 +0200
In-Reply-To: <87in7y5u3h.fsf@toke.dk>
References: <20180219170224.14816-1-toke@toke.dk>
         <20180219170224.14816-2-toke@toke.dk>
         <1525720384.22388.2.camel@sipsolutions.net> <87in7y5u3h.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-05-08 at 12:18 +0200, Toke Høiland-Jørgensen wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > net/mac80211/cfg.c:3762:12: warning: context imbalance in
> > 'ieee80211_get_txq_stats' - different lock contexts for basic block
> 
> Found and fixed all the other warnings, but I'm not seeing this one. And
> I don't really see what is wrong with the locking in that function? What
> am I missing?

This probably came up with sparse/smatch only, I run both sparse and
smatch from "make C=1"

johannes
