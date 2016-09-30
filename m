Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:42348 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932357AbcI3OBa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Sep 2016 10:01:30 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v9 2/2] mac80211: Move reorder-sensitive TX handlers to
        after TXQ dequeue
References: <20160922170420.5193-1-toke@toke.dk>
        <20160922170420.5193-3-toke@toke.dk>
        <1475239765.17481.61.camel@sipsolutions.net>
Date: Fri, 30 Sep 2016 16:01:20 +0200
In-Reply-To: <1475239765.17481.61.camel@sipsolutions.net> (Johannes Berg's
        message of "Fri, 30 Sep 2016 14:49:25 +0200")
Message-ID: <87lgy95vwv.fsf@toke.dk> (sfid-20160930_160134_264946_EF0630BA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Applied, with the nits fixed as discussed.

Awesome, thanks!

> Come to think of it, if somebody is bored ;-) perhaps a hwsim option
> to use TXQs (should be optional I guess) would be nice so we can
> exercise this code with the wpa_supplicant hwsim tests. That would
> have caught the TKIP issues etc. pretty early on too, I think.

Noted. I'll look into that the next time I'm bored ;)

-Toke
