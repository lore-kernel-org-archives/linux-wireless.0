Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:37796 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758080AbaGZCo3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2014 22:44:29 -0400
Received: by mail-la0-f53.google.com with SMTP id gl10so3695800lab.12
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jul 2014 19:44:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140724194358.GY1390@garbanzo.do-not-panic.com>
References: <CA+XVXffvG6GagBPMZF+iogaAeYV0kUoi4BX68J0fxOfsHjE70A@mail.gmail.com>
 <20140703221901.GS1390@garbanzo.do-not-panic.com> <CA+XVXffnDs4oCnyD0NzmyG6=jxqXwUFd+Tj8XAsWGC1bgcMH8A@mail.gmail.com>
 <CA+XVXfewhKpsdVo5Yq3RiKWoDe85h1ne_QVUDtFuC4sfECkV7g@mail.gmail.com>
 <20140708025719.GU1390@garbanzo.do-not-panic.com> <CA+XVXffMM9W76ysqgs=pyAHubavefgjqW5u8bNSZxTX69j7nzg@mail.gmail.com>
 <20140723004132.GX1390@garbanzo.do-not-panic.com> <CA+XVXfd-4jYUy3oz4cOqBprG358X2D9m7Pgq_JrkZKHERm6f3A@mail.gmail.com>
 <CAB=NE6WxUi9J+ODtvojAkT5PN5LsB=SWKhgbzqSkGkbepWeaOg@mail.gmail.com>
 <CA+XVXfcHwOAndEfUo3YtZxbgHtC12qC22QcpVXZFM41WKn0LiQ@mail.gmail.com> <20140724194358.GY1390@garbanzo.do-not-panic.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 25 Jul 2014 19:44:07 -0700
Message-ID: <CAB=NE6V2L1myxtHfFfijSTiOOez9zB=5bTLq+nKhsKD_JjXDew@mail.gmail.com> (sfid-20140726_044438_369827_FE45EB58)
Subject: Re: [PATCH 4/5] cfg80211: accept world/same regdom from driver/user hints
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 24, 2014 at 12:43 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
>> How about adding appropriate regulatory_flags to ensure this can't happen?
>
> That'd be being restrictive and lazy, for instance it'd let a
> manufacturer build an image for phones that would not let users
> plug in another type of 802.11 device. I think this flag is OK
> however if once a device is found that uses wireless-regdb we'd
> simply disallow the 802.11 devices that have the internal reg data
> solution.

I'm growing mor eand more inclined to simply reject all this as
nonsense. I obviously can't and its why I'm seriously trying to find
ways to make this work in a sane architectural way that can scale, but
I hope you can see that this is really only bringing complexities. Can
you please, please try once more, and with all you got to push against
this internal firmware junk. Who the fuck could have decided this was
a good idea?

  Luis
