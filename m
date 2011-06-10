Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56298 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab1FJUHK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 16:07:10 -0400
Received: by iyb14 with SMTP id 14so2451583iyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2011 13:07:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTinPxjBsFQ5n4smD4NwYHikD0kXVNw@mail.gmail.com>
References: <AANLkTikbrzLeeY8Gosw+7Aic1=V=5f+sD382sXwGDWbA@mail.gmail.com>
	<AANLkTi=_gHfEKKC2rsA0pc6Otu5FU4CtVKA2UR85b+GV@mail.gmail.com>
	<AANLkTim9uNH8BzjDM5Ekt3ayBe+7QfE4vnXR0bc-=-Yn@mail.gmail.com>
	<AANLkTikasAe2H+HyoWDr=NbuxW6LJAET-JqATWMmMmq0@mail.gmail.com>
	<1296633772.3624.2.camel@jlt3.sipsolutions.net>
	<20110202113052.GA14126@jm.kir.nu>
	<1296646434.5671.1.camel@jlt3.sipsolutions.net>
	<20110202133839.GA14904@jm.kir.nu>
	<AANLkTimimuho23cY7LR+HN0+VXf4Xo+i4S8EHHz3ORhK@mail.gmail.com>
	<BANLkTi=HZudtUHo1rXZEtoL7r+Lj7TBKPw@mail.gmail.com>
	<BANLkTinPxjBsFQ5n4smD4NwYHikD0kXVNw@mail.gmail.com>
Date: Fri, 10 Jun 2011 22:07:09 +0200
Message-ID: <BANLkTi=O4CSp7EyQSj0_09AE4O+5WGfvLw@mail.gmail.com> (sfid-20110610_220716_492189_D503B8E2)
Subject: Re: Support for Android for mac80211 / cfg80211 802.11 drivers
From: hedwin <hedwin.koning@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If it needs to be part of AOSP then it will be a problem.
If not it entirely depends on those maintaining the specific android "distro".
Some follow the google policy others don't.

Hedwin

On Fri, Jun 10, 2011 at 9:37 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Fri, Jun 10, 2011 at 12:28 PM, hedwin <hedwin.koning@gmail.com> wrote:
>> The problem with nl80211 and wpa_supplicant in android is that afaik
>> libnl is needed, correct?
>> Only problem with libnl is that it is LGPL which doesn't fit into the
>> android license policy.
>> Although this is a mailing list about wireless drivers this also needs
>> to be addressed
>> because it is part of the problem to get wireless support working in android.
>
> Oh wow, so you mean you won't use libnl for any other things in
> android either? Shit out of luck.
>
>  Luis
>
