Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:53334 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751672AbdJFKS3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Oct 2017 06:18:29 -0400
Message-ID: <1507285107.19300.8.camel@sipsolutions.net> (sfid-20171006_121832_450814_FFA7F3D9)
Subject: Re: converting mac80211 to TXQs entirely
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless <linux-wireless@vger.kernel.org>
Cc: nbd <nbd@nbd.name>, Kalle Valo <kvalo@codeaurora.org>
Date: Fri, 06 Oct 2017 12:18:27 +0200
In-Reply-To: <87376wshqn.fsf@toke.dk>
References: <1507205618.2387.19.camel@sipsolutions.net>
         <1507217947.2387.60.camel@sipsolutions.net> <87efqhsgni.fsf@toke.dk>
         <1507221836.2387.66.camel@sipsolutions.net> <878tgps1o7.fsf@toke.dk>
         <1507283082.19300.6.camel@sipsolutions.net> <87376wshqn.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-10-06 at 12:17 +0200, Toke Høiland-Jørgensen wrote:
> 
> Do you have any opinion on whether to use ERR_PTR or change the
> function to an int return and pass the pointer as an argument? At
> least ath10k seems to do the latter (returning -ENOENT when no packet
> is available).

I think using an ERR_PTR is nicer, but I have no strong opinions (I
just don't like out parameters all that much and avoid them when
possible)

johannes
