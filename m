Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:33733 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985AbZDTVUD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 17:20:03 -0400
Received: by bwz7 with SMTP id 7so1448210bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 20 Apr 2009 14:20:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1240259450.4632.20.camel@johannes.local>
References: <20090416111723.904720021@sipsolutions.net> <20090420194430.GG3369@tuxdriver.com>
	<1240257188.4632.19.camel@johannes.local> <2da21fe50904201326m3d843b64u1c3b56d2593bb7cb@mail.gmail.com>
	<1240259450.4632.20.camel@johannes.local>
From: Davide Pesavento <davidepesa@gmail.com>
Date: Mon, 20 Apr 2009 23:19:45 +0200
Message-ID: <2da21fe50904201419v291b2ccpc208b642d1c25f29@mail.gmail.com> (sfid-20090420_232011_940462_749B7E48)
Subject: Re: [PATCH 0/4] mac80211 powersave work
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 20, 2009 at 22:30, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2009-04-20 at 22:26 +0200, Davide Pesavento wrote:
>
>> As I've already reported [1][2], ath9k is currently broken when power
>> saving is enabled, at least on AR5418 hardware. So please don't turn
>> it on by default yet.
>
> But if that's just a hardware/driver bug shouldn't the driver disable PS
> for that combination? It seems wrong to disable PS in the stack by
> default just because one driver has a problem with it, when that driver
> could just unset the PS support bit.
>

You're right. It makes perfect sense.
Unfortunately I don't know how to do it... :-(

Regards,
Davide
