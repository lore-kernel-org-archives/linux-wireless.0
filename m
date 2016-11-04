Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:52727 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755174AbcKDL5t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Nov 2016 07:57:49 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH 3/3] mac80211: fix A-MSDU aggregation with fast-xmit + txq
References: <20161104092754.91649-1-nbd@nbd.name>
        <20161104092754.91649-3-nbd@nbd.name>
Date: Fri, 04 Nov 2016 12:49:16 +0100
In-Reply-To: <20161104092754.91649-3-nbd@nbd.name> (Felix Fietkau's message of
        "Fri, 4 Nov 2016 10:27:54 +0100")
Message-ID: <87wpgjcvnn.fsf@toke.dk> (sfid-20161104_125754_337433_F1E278F9)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

> A-MSDU aggregation alters the QoS header after a frame has been
> enqueued, so it needs to be ready before enqueue and not overwritten
> again afterwards

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
