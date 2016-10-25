Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33612 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750804AbcJYHOq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Oct 2016 03:14:46 -0400
Message-ID: <1477379678.4390.2.camel@sipsolutions.net> (sfid-20161025_091450_037704_72DAD34F)
Subject: Re: Bayesian rate control
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Bj=F6rn?= Smedman <bjornsmedman@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Date: Tue, 25 Oct 2016 09:14:38 +0200
In-Reply-To: <CAGp19xdgsoyx9Sa=uas1OEiFoJdzFChmt20++9e7fJK=Z1ujWQ@mail.gmail.com> (sfid-20161024_221706_899024_253AA60D)
References: <CAGp19xcg1qCP3+JNbuiB7Hx=UjLN7KP55wVJT0sKV-iE12501A@mail.gmail.com>
         <1477286912.4085.1.camel@sipsolutions.net>
         <CAGp19xdgsoyx9Sa=uas1OEiFoJdzFChmt20++9e7fJK=Z1ujWQ@mail.gmail.com>
         (sfid-20161024_221706_899024_253AA60D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-10-24 at 22:17 +0200, Björn Smedman wrote:
> 
> Are there any cards out there that support VHT and use s/w rate
> control (Minstrel)? Just in case I run out of search space. :P

Maybe something that's usable with brcmsmac? Not sure I'd recommend
buying Broadcom NICs though at this point, with them having been bought
out and all (and their upstream support is somewhat spotty, so you
might have a hard time finding the right NIC)

johannes
