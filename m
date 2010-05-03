Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:35099 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507Ab0ECPae (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 11:30:34 -0400
Received: by bwz19 with SMTP id 19so1380148bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 03 May 2010 08:30:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1272900556.3614.42.camel@jlt3.sipsolutions.net>
References: <201005031624.45409.rain_maker@root-forum.org>
	 <v2wa32f33a41005030813m36cbea0blf3963369a934cdac@mail.gmail.com>
	 <1272900556.3614.42.camel@jlt3.sipsolutions.net>
Date: Mon, 3 May 2010 17:30:32 +0200
Message-ID: <w2ka32f33a41005030830y5a79fba2nde23c8bd425c0663@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: remove USB-ID 148f:2573 from rt2500usb driver
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "rain_maker@root-forum.org" <rain_maker@root-forum.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/3/10, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2010-05-03 at 17:13 +0200, Ivo Van Doorn wrote:
>> > This trivial patch removes the id 148f:2573 from rt2500usb driver.
>
>> The ID is confusing indeed, but unfortunately we can't remove this ID,
>> since in the early days people did report they had to use the rt2500usb
>> driver
>> for these devices. So the majority of devices with this ID is indeed
>> rt73usb, but not for all.
>
> Since this seems to come up every couple of weeks, and none of us will
> always be around to remember and answer it, how about capturing that in
> a comment in the code? :)

Good point. :)
I;ll send a patch later today.

Ivo
