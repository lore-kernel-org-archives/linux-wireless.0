Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db5eur01on0103.outbound.protection.outlook.com ([104.47.2.103]:19001
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754959AbeFNMuR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 08:50:17 -0400
From: Omer Efrat <omer.efrat@tandemg.com>
To: Sven Eckelmann <sven@narfation.org>,
        Johannes Berg <johannes@sipsolutions.net>
CC: "b.a.t.m.a.n@lists.open-mesh.org" <b.a.t.m.a.n@lists.open-mesh.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [B.A.T.M.A.N.] [PATCH v2 3/5] batman: use BIT_ULL for
 NL80211_STA_INFO_* attribute types
Date: Thu, 14 Jun 2018 12:50:13 +0000
Message-ID: <VI1PR02MB36317D29E273A4D88231EE029A7D0@VI1PR02MB3631.eurprd02.prod.outlook.com> (sfid-20180614_145022_315175_776C27F6)
References: <1528971137-432-1-git-send-email-omer.efrat@tandemg.com>
 <1567584.jbsRn7ofiA@bentobox>
 <1528974316.26847.0.camel@sipsolutions.net>,<7318287.kp0SrnPS43@bentobox>
In-Reply-To: <7318287.kp0SrnPS43@bentobox>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Eckelmann wrote:
>@Omer: If you want it as cleanup patch then make it clear in the patch tha=
t
>the warning you've showed here is not actually not something which you wil=
l
>see in in the modified code.

I will send v3 as clean up patch.

Omer Efrat.

________________________________________
From: Sven Eckelmann <sven@narfation.org>
Sent: Thursday, June 14, 2018 2:20:17 PM
To: Johannes Berg
Cc: b.a.t.m.a.n@lists.open-mesh.org; Omer Efrat; netdev@vger.kernel.org; li=
nux-wireless@vger.kernel.org
Subject: Re: [B.A.T.M.A.N.] [PATCH v2 3/5] batman: use BIT_ULL for NL80211_=
STA_INFO_* attribute types

On Donnerstag, 14. Juni 2018 13:05:16 CEST Johannes Berg wrote:
[...]
> > in commit 739960f128e5 ("cfg80211/nl80211: Add support for
> > NL80211_STA_INFO_RX_DURATION")
>
> Yeah, which actually means this patch isn't needed?
>
> BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT) is fine since
> NL80211_STA_INFO_EXPECTED_THROUGHPUT is actually =3D=3D 27.

Hadn't verified this before but this would make sense. So no fixes here - j=
ust
some "cleanup" patch to make these tests more consistent. Thanks for checki=
ng.

@Omer: If you want it as cleanup patch then make it clear in the patch that
the warning you've showed here is not actually not something which you will
see in in the modified code.

Kind regards,
        Sven
