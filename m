Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41104 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754546AbdEQOGc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 May 2017 10:06:32 -0400
Message-ID: <1495029987.2442.19.camel@sipsolutions.net> (sfid-20170517_160925_177095_18DF5DA4)
Subject: Re: [PATCH v3] mac80211: Dynamically set CoDel parameters per
 station
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Wed, 17 May 2017 16:06:27 +0200
In-Reply-To: <20170406093826.16626-1-toke@toke.dk> (sfid-20170406_113851_927923_E0E6B713)
References: <20170405161810.30671-1-toke@toke.dk>
         <20170406093826.16626-1-toke@toke.dk>
         (sfid-20170406_113851_927923_E0E6B713)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-04-06 at 11:38 +0200, Toke Høiland-Jørgensen wrote:
> CoDel can be too aggressive if a station sends at a very low rate,
> leading reduced throughput. This gets worse the more stations are
> present, as each station gets more bursty the longer the round-robin
> scheduling between stations takes.
> 
[...]

I've applied this now (with some minor fixups) - the whole discussion
didn't really conclude in anything, and we can just try it.

johannes
