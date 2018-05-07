Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:44321 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752888AbeEGVTZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 17:19:25 -0400
Date: Mon, 07 May 2018 23:19:21 +0200
In-Reply-To: <1525720384.22388.2.camel@sipsolutions.net>
References: <20180219170224.14816-1-toke@toke.dk> <20180219170224.14816-2-toke@toke.dk> (sfid-20180219_180300_682375_800CE1A2) <1525720384.22388.2.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: Re: [PATCH 1/3] cfg80211: Expose TXQ stats and parameters to userspace
To: Johannes Berg <johannes@sipsolutions.net>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
From: =?ISO-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@toke.dk>
Message-ID: <DDA0225E-5A86-438A-8A57-0EC9113EBE02@toke.dk> (sfid-20180507_231928_785072_4D64E0EC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 7 May 2018 21:13:04 CEST, Johannes Berg <johannes@sipsolutions=2Enet> w=
rote:
>On Mon, 2018-02-19 at 18:02 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wrote=
:
>> This adds support for exporting the mac80211 TXQ stats via nl80211 by
>> way of a nested TXQ stats attribute, as well as for configuring the
>> quantum and limits that were previously only changeable through
>debugfs=2E
>
>So I finally (sorry) decided to apply this, but I get a few issues with
>it (aside from trivial rebase issues)=2E If you're not able to fix them
>now let me know and I can:

Great! I'll rebase and fix those and resend :)

Is the iw patch fine as-is?

-Toke
