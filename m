Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:43906 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752796AbeEGVU3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 17:20:29 -0400
Message-ID: <1525728025.6222.0.camel@sipsolutions.net> (sfid-20180507_232032_467946_68C5C30D)
Subject: Re: [PATCH 1/3] cfg80211: Expose TXQ stats and parameters to
 userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Mon, 07 May 2018 23:20:25 +0200
In-Reply-To: <DDA0225E-5A86-438A-8A57-0EC9113EBE02@toke.dk>
References: <20180219170224.14816-1-toke@toke.dk>
         <20180219170224.14816-2-toke@toke.dk>
         (sfid-20180219_180300_682375_800CE1A2) <1525720384.22388.2.camel@sipsolutions.net>
         <DDA0225E-5A86-438A-8A57-0EC9113EBE02@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-05-07 at 23:19 +0200, Toke Høiland-Jørgensen wrote:
> 
> On 7 May 2018 21:13:04 CEST, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Mon, 2018-02-19 at 18:02 +0100, Toke Høiland-Jørgensen wrote:
> > > This adds support for exporting the mac80211 TXQ stats via nl80211 by
> > > way of a nested TXQ stats attribute, as well as for configuring the
> > > quantum and limits that were previously only changeable through
> > 
> > debugfs.
> > 
> > So I finally (sorry) decided to apply this, but I get a few issues with
> > it (aside from trivial rebase issues). If you're not able to fix them
> > now let me know and I can:
> 
> Great! I'll rebase and fix those and resend :)
> 
> Is the iw patch fine as-is?

Good question, let me review it :-)

johannes
