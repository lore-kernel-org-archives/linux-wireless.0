Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:42529 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751334AbdJFKaa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Oct 2017 06:30:30 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org,
        =?utf-8?Q?Micha=C5=82?= Kazior <kazikcz@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 2/2] mac80211: only remove AP VLAN frames from TXQ
In-Reply-To: <20171006095333.26335-2-johannes@sipsolutions.net>
References: <20171006095333.26335-1-johannes@sipsolutions.net> <20171006095333.26335-2-johannes@sipsolutions.net>
Date: Fri, 06 Oct 2017 12:30:24 +0200
Message-ID: <87wp48r2kf.fsf@toke.dk> (sfid-20171006_123032_233905_CB7DDA68)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> When removing an AP VLAN interface, mac80211 currently purges
> the entire TXQ for the AP interface. Fix this by using the FQ
> API introduced in the previous patch to filter frames.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
