Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55112 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752066AbdLLLqD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Dec 2017 06:46:03 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Wireless <linux-wireless@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the mac80211-next tree
References: <20171212125805.5f7813fd@canb.auug.org.au>
        <1513068419.26976.86.camel@sipsolutions.net> <87r2s0uxry.fsf@toke.dk>
Date: Tue, 12 Dec 2017 13:45:55 +0200
In-Reply-To: <87r2s0uxry.fsf@toke.dk> ("Toke \=\?utf-8\?Q\?H\=C3\=B8iland-J\?\=
 \=\?utf-8\?Q\?\=C3\=B8rgensen\=22's\?\= message of
        "Tue, 12 Dec 2017 09:59:45 +0100")
Message-ID: <87fu8gqido.fsf@kamboji.qca.qualcomm.com> (sfid-20171212_124623_649449_51653BCA)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:

>> Sorry for the inconvenience, I hadn't realized mt76 went in now.
>
> Yeah, hadn't expected these streams to cross either.

I did ask[1] if everyone are ok that I apply mt76 and I didn't get any
comments, I guess I need to make more noise next time when I'm applying
a new driver.

[1] https://lkml.kernel.org/r/87wp22jzzb.fsf@purkki.adurom.net

--=20
Kalle Valo
