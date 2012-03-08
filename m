Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56411 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758891Ab2CHWdv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 17:33:51 -0500
Received: by yenl12 with SMTP id l12so587266yen.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Mar 2012 14:33:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <loom.20120308T231306-198@post.gmane.org>
References: <4F59274D.7060708@gmail.com> <CAB=NE6Wiwo2Cj8-UMqGQik7Hv=LMZ=+9ifa8Qia8OPuXFgEyKw@mail.gmail.com>
 <4F592BE0.70706@gmail.com> <loom.20120308T231306-198@post.gmane.org>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 8 Mar 2012 14:33:30 -0800
Message-ID: <CAB=NE6U-_heMdw0PkWPQYXs5TvDoA9d6eJnxKwDuaKwu1uLMgA@mail.gmail.com> (sfid-20120308_233357_280108_6F7AA1A6)
Subject: Re: Google Summer of Code 2012 - Application for the Linux Foundation submitted
To: Martin Schleier <drahemmaps@gmx.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 8, 2012 at 2:25 PM, Martin Schleier <drahemmaps@gmx.net> wrote:
> Till Kamppeter <till.kamppeter@...> writes:
>
>>
>> On 03/08/2012 10:45 PM, Luis R. Rodriguez wrote:
>> >
>> > So one idea I had was working on open firmware for ath9k_htc. We don't
>> > have the resources to open that up but can likely provide under NDA
>> > source code to let it get cleaned up for public release. If this is
>> > reasonable I'll throw it on.
>> >
>>
>> OK, please do it.
>>
>>     Till
>
> Wait wait wait... qualcomm/Atheros does not have the resources, so how on earth
> should a student (or students) actually do that?
>
> Given the TODO over at
> <http://wireless.kernel.org/en/users/Drivers/ath9k_htc#TODO> [Scroll down till
> you get "fixed in the firmware. ]. This would be at least one years of full-time
> work for a small team of trained code-monkey and therefore this "project" is
> highly unrealistic.

It didn't take one year to open up the ar9170.fw [0] which lead to
carl9170.fw [1] and we even had two drivers from this work. I think
you underestimate our potential ;)

[0] http://wireless.kernel.org/en/users/Drivers/ar9170.fw
[1] http://wireless.kernel.org/en/users/Drivers/carl9170.fw

> Maybe we should stick to something less complicated.

Lets not undermine potential.

> Like extending PID to use MCS rates, or implementing a TPC control algorithm
> [this is stuff, every drivers could use].

PID? Hah, PID is dead. And TPC -- well... that requires a long answer.
Just finding documentation on TPC and what vendors do for TPC is as
much hard work as writing open firmware. But hey, its a wiki, feel
free to add what you think might be good, you can, and please be
verbose ;)

http://wireless.kernel.org/en/developers/GSoC/2012

  Luis
