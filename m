Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:39362 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932673AbcI3MpM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Sep 2016 08:45:12 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v9 2/2] mac80211: Move reorder-sensitive TX handlers to
        after TXQ dequeue
References: <20160922170420.5193-1-toke@toke.dk>
        <20160922170420.5193-3-toke@toke.dk>
        <1475231220.17481.32.camel@sipsolutions.net> <87y4295zpy.fsf@toke.dk>
        <1475239412.17481.59.camel@sipsolutions.net>
Date: Fri, 30 Sep 2016 14:45:09 +0200
In-Reply-To: <1475239412.17481.59.camel@sipsolutions.net> (Johannes Berg's
        message of "Fri, 30 Sep 2016 14:43:32 +0200")
Message-ID: <87ponl5zfu.fsf@toke.dk> (sfid-20160930_144515_428750_191AC604)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> Not sure if you want a v10, or if you're satisfied with the above
>> comments and will just fix up the nits on merging?
>> 
>
> I'll fix it up. Thanks!

Cool, thanks :)

-Toke
