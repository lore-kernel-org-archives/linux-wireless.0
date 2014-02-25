Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f65.google.com ([74.125.82.65]:38727 "EHLO
	mail-wg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbaBYQQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 11:16:07 -0500
Received: by mail-wg0-f65.google.com with SMTP id l18so171871wgh.4
        for <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 08:16:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJZjf_yu99H2dNLph8ynWhXwSso-4HStrO9HA66MD5kE5DhRjw@mail.gmail.com>
References: <20120418203543.GA16000@x61.home>
	<20120425122554.GD2466@redhat.com>
	<20120503182853.GA12461@mac.home>
	<20121226185425.GA12627@x61.home>
	<20130107110759.GC6931@redhat.com>
	<20130603085239.GA26920@mac.home>
	<20130603141804.GA2146@redhat.com>
	<20130611185120.GA8751@x61.home>
	<20140218105755.GD1741@redhat.com>
	<CAJZjf_yu99H2dNLph8ynWhXwSso-4HStrO9HA66MD5kE5DhRjw@mail.gmail.com>
Date: Tue, 25 Feb 2014 16:16:06 +0000
Message-ID: <CAKFtS+oUopJYoXfs+KbzJx1=OWjYikyf2YK7S6NZhmAygyKJKA@mail.gmail.com> (sfid-20140225_171612_476268_ED83277F)
Subject: Re: Power saving features for iwl4965
From: Pedro Francisco <pedrogfrancisco.public@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Tino Keitel <tino.keitel@tikei.de>,
	ML linux-wireless <linux-wireless@vger.kernel.org>,
	Pedro Francisco <pedrogfrancisco@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-02-20 12:08 GMT+00:00 Pedro Francisco <pedrogfrancisco@gmail.com>:
> On Tue, Feb 18, 2014 at 10:57 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> On Tue, Jun 11, 2013 at 08:51:20PM +0200, Tino Keitel wrote:
>>> On Mon, Jun 03, 2013 at 16:18:05 +0200, Stanislaw Gruszka wrote:
>>>
>>> > Could you try this experimental patch?
>>>
>>> Hi,
>>>
>>> on top of kernel 3.9.4 (with TuxOnIce patch), iwconfig wlan0 power on
>>> now saves more than 1 W on my ThinkPad X61s with iwl4965. I can finally
>>> switch to a recent kernel. Thanks a lot.
>>
>> This patch stuck on mailing list far too long, I'll post it. Even if it
>> crash firmware on 3945, power save is disabled by default.
>
> Ok!
> The patch was not forgotten, just indefinitely delayed :/
> Now that I can compile a kernel in 10 minutes instead of >1h, I'll try
> to test it :)

Leaving the computer running for 24h gave no signs of any kind of
issues, besides a few AP timeout after 500ms.

If you wish me to further test more patches, please do include me in CC.
However, my access to the 3945 hardware is now very reduced, so I'll
probably take several weeks to test the patches, if at all.

Thank you for your patience, time and code since my first half-made
debugging of the HW scan crash in the iwl3945 firmware :)
-- 
Pedro
