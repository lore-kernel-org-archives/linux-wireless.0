Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:39217 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbYKLVHq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 16:07:46 -0500
Received: by fg-out-1718.google.com with SMTP id 19so507202fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2008 13:07:44 -0800 (PST)
Message-ID: <45e8e6c40811121307v32ca4c2cq77714ff14bec4563@mail.gmail.com> (sfid-20081112_220751_119505_D97FAAF4)
Date: Wed, 12 Nov 2008 13:07:44 -0800
From: "Andrey Yurovsky" <andrey@cozybit.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: libertas_tf should replace libertas_usb on compat-wireless?
Cc: "Dan Williams" <dcbw@redhat.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"David Woodhouse" <dwmw2@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis Carlos Cobo" <luisca@cozybit.com>
In-Reply-To: <20081112195515.GA15803@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <43e72e890811111632x2c641d2cmeb69c0a0ea95382e@mail.gmail.com>
	 <1226505205.13536.13.camel@localhost.localdomain>
	 <1226512649.3940.0.camel@localhost.localdomain>
	 <20081112195515.GA15803@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

libertas_tf is a softmac driver developed mainly so that XO's can run
hostapd and the like.  libertas is the general (fullmac) driver and,
in my opinion, should be the one users get unless they specifically
wanted libertas_tf because they're experimenting with AP mode or other
mac80211 features.  So I guess I'd vote for libertas over libertas_tf
at this time, for what it's worth.

  -Andrey

On Wed, Nov 12, 2008 at 11:55 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Wed, Nov 12, 2008 at 09:57:29AM -0800, Dan Williams wrote:
>> On Wed, 2008-11-12 at 10:53 -0500, Dan Williams wrote:
>> > On Tue, 2008-11-11 at 16:32 -0800, Luis R. Rodriguez wrote:
>> > > By default do we want users of compat-wireless to get libertas_usb or
>> > > libertas_tf? Both drivers are for Marvell Libertas 8388 USB 802.11b/g
>> > > cards so we need to pick one.
>> >
>> > I think libertas_tf is still experimental at this time.  Louis could
>> > elaborate more.
>>
>> And that would be Luis (luisca) not Louis.  Sorry Luis! :)
>
> Heh, thanks. Hm, I thik Luis is on his trip around the world.
>
>  Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
