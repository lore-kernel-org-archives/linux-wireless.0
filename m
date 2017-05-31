Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46553 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751009AbdEaMxw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 May 2017 08:53:52 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Adrian Chadd <adrian@freebsd.org>
CC: Norik Dzhandzhapanyan <norikd@ethertronics.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] Per chain RSSI reporting
Date: Wed, 31 May 2017 12:53:47 +0000
Message-ID: <87poepmbls.fsf@kamboji.qca.qualcomm.com> (sfid-20170531_145355_863320_C9FA1378)
References: <SN1PR08MB1373BF583E9CE2AA6A0F6381B0FC0@SN1PR08MB1373.namprd08.prod.outlook.com>
        <CAJ-VmomiKOgV4pJWNKdOCzsUJZYEixvP4p5bQ9X1FBqAGk_o0w@mail.gmail.com>
In-Reply-To: <CAJ-VmomiKOgV4pJWNKdOCzsUJZYEixvP4p5bQ9X1FBqAGk_o0w@mail.gmail.com>       (Adrian
 Chadd's message of "Fri, 26 May 2017 18:12:18 -0700")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adrian Chadd <adrian@freebsd.org> writes:

> I have something local that I've been meaning to push up to do this,
> but with no smoothing. Ideally (!) smoothing is done optionally in
> mac80211.
>
> What do you think about just committing the per-chain RSSI stuff to
> mac80211 so it shows up right now, and then we figure out how to
> express the smoothing in mac80211 or further up the layers?

I think this is a good approach.

--=20
Kalle Valo=
