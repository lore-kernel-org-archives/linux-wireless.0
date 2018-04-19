Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:49224 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750884AbeDSJwV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Apr 2018 05:52:21 -0400
Message-ID: <1524131536.3024.16.camel@sipsolutions.net> (sfid-20180419_115225_323370_CE152715)
Subject: Re: [PATCH 0/3] Export TXQ parameters and statistics via nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Thu, 19 Apr 2018 11:52:16 +0200
In-Reply-To: <8736zr1rjh.fsf@toke.dk> (sfid-20180419_112023_143492_C28A4BC7)
References: <20180219170224.14816-1-toke@toke.dk> <8736zr1rjh.fsf@toke.dk>
         (sfid-20180419_112023_143492_C28A4BC7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-04-19 at 11:20 +0200, Toke Høiland-Jørgensen wrote:
> Toke Høiland-Jørgensen <toke@toke.dk> writes:
> 
> > This series adds TXQ parameters and statistics that were previously only
> > available through debugfs to the nl80211 userspace interface and the
> > cfg80211 kernel interface. Patches for iw to print the statistics and
> > change the settings are included.
> 
> So this patch set is now three months old. Any chance of actually
> getting it, you know, merged? Or is there something more I need to do? :)

I was just thinking about it yesterday, "sighing" that I'll need to make
a decision even though I don't really know it well and can't even say if
another API would be better :-)

I think I'll take it, but I guess I'll need to review it again.

johannes
