Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37421 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab1FJTiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 15:38:16 -0400
Received: by iwn34 with SMTP id 34so2419891iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2011 12:38:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=HZudtUHo1rXZEtoL7r+Lj7TBKPw@mail.gmail.com>
References: <AANLkTikbrzLeeY8Gosw+7Aic1=V=5f+sD382sXwGDWbA@mail.gmail.com>
 <AANLkTi=_gHfEKKC2rsA0pc6Otu5FU4CtVKA2UR85b+GV@mail.gmail.com>
 <AANLkTim9uNH8BzjDM5Ekt3ayBe+7QfE4vnXR0bc-=-Yn@mail.gmail.com>
 <AANLkTikasAe2H+HyoWDr=NbuxW6LJAET-JqATWMmMmq0@mail.gmail.com>
 <1296633772.3624.2.camel@jlt3.sipsolutions.net> <20110202113052.GA14126@jm.kir.nu>
 <1296646434.5671.1.camel@jlt3.sipsolutions.net> <20110202133839.GA14904@jm.kir.nu>
 <AANLkTimimuho23cY7LR+HN0+VXf4Xo+i4S8EHHz3ORhK@mail.gmail.com> <BANLkTi=HZudtUHo1rXZEtoL7r+Lj7TBKPw@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 10 Jun 2011 12:37:56 -0700
Message-ID: <BANLkTinPxjBsFQ5n4smD4NwYHikD0kXVNw@mail.gmail.com> (sfid-20110610_213820_007278_54C46623)
Subject: Re: Support for Android for mac80211 / cfg80211 802.11 drivers
To: hedwin <hedwin.koning@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 10, 2011 at 12:28 PM, hedwin <hedwin.koning@gmail.com> wrote:
> The problem with nl80211 and wpa_supplicant in android is that afaik
> libnl is needed, correct?
> Only problem with libnl is that it is LGPL which doesn't fit into the
> android license policy.
> Although this is a mailing list about wireless drivers this also needs
> to be addressed
> because it is part of the problem to get wireless support working in android.

Oh wow, so you mean you won't use libnl for any other things in
android either? Shit out of luck.

  Luis
