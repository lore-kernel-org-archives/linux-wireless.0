Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:34757 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934108AbcKDLwq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Nov 2016 07:52:46 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH 2/3] mac80211: remove bogus skb vif assignment
References: <20161104092754.91649-1-nbd@nbd.name>
        <20161104092754.91649-2-nbd@nbd.name>
Date: Fri, 04 Nov 2016 12:47:32 +0100
In-Reply-To: <20161104092754.91649-2-nbd@nbd.name> (Felix Fietkau's message of
        "Fri, 4 Nov 2016 10:27:53 +0100")
Message-ID: <871syreaaz.fsf@toke.dk> (sfid-20161104_125252_252546_4AB1D662)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

> The call to ieee80211_txq_enqueue overwrites the vif pointer with the
> codel enqueue time, so setting it just before that call makes no
> sense.

Yeah, I think this was leftover from earlier version when the flow was
different. Or maybe I just missed it...

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

-Toke
