Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:43492 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbeIEQLX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 12:11:23 -0400
Message-ID: <1536147683.3528.12.camel@sipsolutions.net> (sfid-20180905_134134_899874_E6692541)
Subject: Re: [PATCH] mac80211: TDLS: fix skb queue/priority assignment
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>
Date: Wed, 05 Sep 2018 13:41:23 +0200
In-Reply-To: <87k1o05g04.fsf@toke.dk>
References: <20180905113402.7665-1-johannes@sipsolutions.net>
         <1536147453.3528.11.camel@sipsolutions.net> <87k1o05g04.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-09-05 at 13:40 +0200, Toke Høiland-Jørgensen wrote:
> 
> Guess we'll have to deal with everything else if we ever move management
> frames onto the TXQ path as well...

Depends on whether we care for management frame priorities or not ... so
far we haven't really.

johannes
