Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vserver.eikelenboom.it ([84.200.39.61]:49617 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaA0KsW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 05:48:22 -0500
Date: Mon, 27 Jan 2014 11:48:19 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Message-ID: <1958591532.20140127114819@eikelenboom.it> (sfid-20140127_114826_122469_7263620C)
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] cfg80211: allow reprocessing of pending requests
In-Reply-To: <CAB=NE6Wkvfm_VddBqSqP8HGHLztkDzDSf46rHNdK3nUYnTerYg@mail.gmail.com>
References: <1387486399-4053-1-git-send-email-mcgrof@do-not-panic.com> <1387486399-4053-2-git-send-email-mcgrof@do-not-panic.com> <1389108849.4645.12.camel@jlt4.sipsolutions.net> <284626761.20140123141626@eikelenboom.it> <CAB=NE6Wkvfm_VddBqSqP8HGHLztkDzDSf46rHNdK3nUYnTerYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Saturday, January 25, 2014, 12:14:37 AM, you wrote:

> On Thu, Jan 23, 2014 at 5:16 AM, Sander Eikelenboom
> <linux@eikelenboom.it> wrote:
>>
>> Tuesday, January 7, 2014, 4:34:09 PM, you wrote:
>>
>>> On Thu, 2013-12-19 at 12:53 -0800, Luis R. Rodriguez wrote:
>>>> This addresses the RCU component of allowing us to reprocess
>>>> the last regulatory request.
>>
>>> That commit message makes very little sense to me.
>>
>>> johannes
>>
>> Hi Luis,
>>
>> It seems i haven't seen any response from you regarding this
>> patch series ? (could have been i missed it, i'm not subscribed to linux-wireless)

> I quit my job, went on vacation and during vacation lost my phone and
> the ChromeBook PIxel [0] I bought and had installed my own OS on
> decided to poop out thanks to the stupidity behind Google's policy on
> a half assed developer mode on that thing. In summary I have been
> ramping up a development environment, ramping up on a new job, have no
> 802.11 hardware to even test any alternative I come up with so -- I
> think this will take a bit of time, but am starting to get at least a
> development environment going again. Hope to look at this by next
> week.

NP, good luck with getting everything back together,
I was just wondering if it was still on someone's todo :-)


> [0] https://plus.google.com/101487746899672598413/posts/9rS6qvGU8Q1

>   Luis


