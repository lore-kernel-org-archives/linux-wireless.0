Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37738 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932991Ab2FGVrV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 17:47:21 -0400
Received: by yhmm54 with SMTP id m54so822732yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 14:47:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FD11B47.10002@lwfinger.net>
References: <CAHsu+b_wQOuhbBkx25CZ2cai5VVos7zK3s=EiPBy_+OnXWiWaA@mail.gmail.com>
	<1339014959.4523.0.camel@jlt3.sipsolutions.net>
	<CAHsu+b-ByqBaci9W-oS3OPEK3LdRcuGphtQPOTQ02hPWNpWgQw@mail.gmail.com>
	<1339053364.4517.0.camel@jlt3.sipsolutions.net>
	<CAHsu+b9UjkF6VM_YjJkHVDQzrZqsWqmG-XJKFNeSCdWGbdEngw@mail.gmail.com>
	<20120607180325.7752b3c0@milhouse>
	<1339094215.4630.7.camel@jlt3.sipsolutions.net>
	<1339102567.4630.8.camel@jlt3.sipsolutions.net>
	<4FD11B47.10002@lwfinger.net>
Date: Thu, 7 Jun 2012 23:47:20 +0200
Message-ID: <CAHsu+b9=4i1oSni1onKAKqH4FZ26nye=7GifnnJO-6c5gCaWpQ@mail.gmail.com> (sfid-20120607_234724_975444_E766E734)
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i] >= n_queues))
From: Andre Heider <a.heider@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	=?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	=?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 7, 2012 at 11:21 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 06/07/2012 03:56 PM, Johannes Berg wrote:
>>
>> On Thu, 2012-06-07 at 20:36 +0200, Johannes Berg wrote:
>>
>>> However, it's also possible to actually *use* the new mac80211 feature.
>>> That would also help with IEEE80211_TX_CTL_SEND_AFTER_DTIM, you could
>>> ask mac80211 to use a separate HW queue for it (for tx_ring_mcast.) This
>>> may be quicker.
>>
>>
>> This might do it, I haven't tested it at all:
>>
>> http://p.sipsolutions.net/3c6b003bb06e5298.txt
>
>
> With that patch, the driver never loads the firmware. I have not yet found
> the reason.

Same here.
