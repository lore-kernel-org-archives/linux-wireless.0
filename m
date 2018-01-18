Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58042 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752184AbeARErQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 23:47:16 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Christopher =?utf-8?Q?D=C3=ADaz?= Riveros <chrisadr@gentoo.org>
Cc: johannes@sipsolutions.net, davem@davemloft.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH-next] debugfs_sta: Remove unneeded semicolons
References: <20180117210300.23479-1-chrisadr@gentoo.org>
Date: Thu, 18 Jan 2018 06:47:12 +0200
In-Reply-To: <20180117210300.23479-1-chrisadr@gentoo.org> ("Christopher
 =?utf-8?Q?D=C3=ADaz?=
        Riveros"'s message of "Wed, 17 Jan 2018 16:03:00 -0500")
Message-ID: <87d127zsbz.fsf@purkki.adurom.net> (sfid-20180118_054721_031071_98CA9510)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christopher D=C3=ADaz Riveros <chrisadr@gentoo.org> writes:

> Trivial fix removes unneeded semicolons after switch blocks.
>
> Signed-off-by: Christopher D=C3=ADaz Riveros <chrisadr@gentoo.org>
> ---
>  net/mac80211/debugfs_sta.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

The correct title prefix should be "mac80211:", not "debugfs_sta:".

--=20
Kalle Valo
