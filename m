Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:45162 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaAXXO7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 18:14:59 -0500
Received: by mail-lb0-f176.google.com with SMTP id w7so3028454lbi.35
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jan 2014 15:14:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <284626761.20140123141626@eikelenboom.it>
References: <1387486399-4053-1-git-send-email-mcgrof@do-not-panic.com>
 <1387486399-4053-2-git-send-email-mcgrof@do-not-panic.com>
 <1389108849.4645.12.camel@jlt4.sipsolutions.net> <284626761.20140123141626@eikelenboom.it>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 24 Jan 2014 15:14:37 -0800
Message-ID: <CAB=NE6Wkvfm_VddBqSqP8HGHLztkDzDSf46rHNdK3nUYnTerYg@mail.gmail.com> (sfid-20140125_001502_701226_8A0A00DA)
Subject: Re: [PATCH 1/3] cfg80211: allow reprocessing of pending requests
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 23, 2014 at 5:16 AM, Sander Eikelenboom
<linux@eikelenboom.it> wrote:
>
> Tuesday, January 7, 2014, 4:34:09 PM, you wrote:
>
>> On Thu, 2013-12-19 at 12:53 -0800, Luis R. Rodriguez wrote:
>>> This addresses the RCU component of allowing us to reprocess
>>> the last regulatory request.
>
>> That commit message makes very little sense to me.
>
>> johannes
>
> Hi Luis,
>
> It seems i haven't seen any response from you regarding this
> patch series ? (could have been i missed it, i'm not subscribed to linux-wireless)

I quit my job, went on vacation and during vacation lost my phone and
the ChromeBook PIxel [0] I bought and had installed my own OS on
decided to poop out thanks to the stupidity behind Google's policy on
a half assed developer mode on that thing. In summary I have been
ramping up a development environment, ramping up on a new job, have no
802.11 hardware to even test any alternative I come up with so -- I
think this will take a bit of time, but am starting to get at least a
development environment going again. Hope to look at this by next
week.

[0] https://plus.google.com/101487746899672598413/posts/9rS6qvGU8Q1

  Luis
