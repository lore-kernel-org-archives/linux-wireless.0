Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34629 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755028AbcIMHRX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 03:17:23 -0400
Message-ID: <1473751037.12982.0.camel@sipsolutions.net> (sfid-20160913_091737_507435_D11421EF)
Subject: Re: [PATCH v3] mac80211: Re-structure aqm debugfs output and keep
 CoDel stats per txq
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Tue, 13 Sep 2016 09:17:17 +0200
In-Reply-To: <20160912135543.26347-1-toke@toke.dk> (sfid-20160912_155610_196048_AB181E36)
References: <20160811151156.6485-1-toke@toke.dk>
         <20160912135543.26347-1-toke@toke.dk>
         (sfid-20160912_155610_196048_AB181E36)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-09-12 at 15:55 +0200, Toke Høiland-Jørgensen wrote:
> Currently the 'aqm' stats in mac80211 only keeps overlimit drop
> stats,
> not CoDel stats. This moves the CoDel stats into the txqi structure
> to
> keep them per txq in order to show them in debugfs.
> 
> In addition, the aqm debugfs output is restructured by splitting it
> up
> into three files: One global per phy, one per netdev and one per
> station, in the appropriate directories. The files are all called
> aqm,
> and are only created if the driver supports the wake_tx_queue op
> (rather
> than emitting an error on open as previously).
> 
Applied, thanks.

johannes
