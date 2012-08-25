Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:59015 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab2HYFQ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Aug 2012 01:16:29 -0400
Received: by vcbfk26 with SMTP id fk26so2911721vcb.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Aug 2012 22:16:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50381437.7040903@lwfinger.net>
References: <CAE3CJbkhmZ75gBjEToshQ2M9Xu7ciVrDtv8n2DVZepnhBoNt-Q@mail.gmail.com>
	<50365AC8.7030503@lwfinger.net>
	<CAE3CJbm5a0hZ8uWT8yU5Z8vbKX2HNwZ2uPUFULGA-3no1XFc_Q@mail.gmail.com>
	<5036660B.9020208@lwfinger.net>
	<CAE3CJbkodiw7kZ9F1PQrzZA2hSCF2PAwPAw-UHMwKhC2-6Ky2g@mail.gmail.com>
	<50381437.7040903@lwfinger.net>
Date: Fri, 24 Aug 2012 22:16:28 -0700
Message-ID: <CAE3CJb=Zi12MVpBNGE3kOu00x3b1sZ7S67TCyBty3GkPbtoJXA@mail.gmail.com> (sfid-20120825_071633_418117_1CDFCA17)
Subject: Re: Question about ath9k/mac80211 Driver
From: Patrick Connolly <pjc999@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The kernel is 2.6.32
-Patrick

On Fri, Aug 24, 2012 at 4:54 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 08/24/2012 06:38 PM, Patrick Connolly wrote:
>>
>> Okay so I built "iw" version 0.9.22 successfully (after much grief).
>> The help page shows that "set bitrates" is now supported:
>>
>>          dev <devname> set bitrates [legacy-<2.4|5> <legacy rate in
>> Mbps>*]
>>
>>
>>   but when I try to use it I get:
>>
>>         # iw dev wlan0 set bitrates legacy-2.4 1 2 5.5 11
>>         command failed: Operation not supported (-95)
>>
>> ...so what does this mean?  Is it "iw" or the driver that lacks the
>> support?
>
>
> I would think that your kernel is too old. What version are you running?
>
> Larry
>
>
