Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:42459 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751334AbdJFKaU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Oct 2017 06:30:20 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org,
        =?utf-8?Q?Micha=C5=82?= Kazior <kazikcz@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 1/2] fq: support filtering a given tin
In-Reply-To: <20171006095333.26335-1-johannes@sipsolutions.net>
References: <20171006095333.26335-1-johannes@sipsolutions.net>
Date: Fri, 06 Oct 2017 12:30:15 +0200
Message-ID: <87zi94r2ko.fsf@toke.dk> (sfid-20171006_123024_018064_B54B2B27)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> Add to the FQ API a way to filter a given tin, in order to
> remove frames that fulfil certain criteria according to a
> filter function.
>
> This will be used by mac80211 to remove frames belonging to
> an AP VLAN interface that's being removed.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
