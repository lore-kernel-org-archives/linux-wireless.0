Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42385 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab2CJWdn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 17:33:43 -0500
Received: by dajr28 with SMTP id r28so3160304daj.19
        for <linux-wireless@vger.kernel.org>; Sat, 10 Mar 2012 14:33:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1331364931.3348.0.camel@jlt3.sipsolutions.net>
References: <1331298825-22314-1-git-send-email-helmut.schaa@googlemail.com>
	<CAGXE3d_58okToGOH146vDsgZ_Jf01iZAxDX0pxwBMGSo0BvZYg@mail.gmail.com>
	<CAJ-Vmo=WLa6Lc7u4fjPNDjVP5MT9+OJ-qNP-zBL+T=ajOHSN7g@mail.gmail.com>
	<1331364931.3348.0.camel@jlt3.sipsolutions.net>
Date: Sat, 10 Mar 2012 14:33:42 -0800
Message-ID: <CAJ-VmonFHC8svz0CADTvJcy76HYOhCQGquK4WTEBnpZTPQxi+w@mail.gmail.com> (sfid-20120310_233346_596559_D384C3AA)
Subject: Re: [PATCH] mac80211: Disable MCS > 7 in minstrel_ht when STA uses
 static SMPS
From: Adrian Chadd <adrian@freebsd.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 March 2012 23:35, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2012-03-09 at 22:40 -0800, Adrian Chadd wrote:
>> .. hm, I was wondering about SMPS. Why not RTS? Wouldn't that
>> wake up the other RX chains?
>
> (corrected to RTS)
>
> That would be "dynamic SMPS", "static SMPS" means your chains are truly
> turned off and can't even be revived by RTS.

Ok. I'll start tinkering with this soon in FreeBSD, so I'll do some
interoperability testing with ath9k+FreeBSD and whatever else I can
get my hands on.

I'll report back if things behave strangely.


Adrian
