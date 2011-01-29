Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56208 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab1A2NeX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Jan 2011 08:34:23 -0500
Message-ID: <4D441756.5010702@openwrt.org>
Date: Sat, 29 Jan 2011 14:34:14 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Daniel Halperin <dhalperi@cs.washington.edu>
CC: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
Subject: Re: hti->control_chan is 15??
References: <4D4345A8.6060806@candelatech.com> <4D435D76.2040703@candelatech.com> <AANLkTimji+Y0KfDCzWDX63KfOjRFzxgKbVAq6HhMcw20@mail.gmail.com> <4D4362BF.7050208@candelatech.com> <AANLkTimG05o=y2xGXh0YAmRqbuixifKp7xgmU7sH61Uf@mail.gmail.com>
In-Reply-To: <AANLkTimG05o=y2xGXh0YAmRqbuixifKp7xgmU7sH61Uf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-01-29 1:48 AM, Daniel Halperin wrote:
> On Fri, Jan 28, 2011 at 4:43 PM, Ben Greear <greearb@candelatech.com> wrote:
>> My AP is an off-the-shelf Netgear:
>> WNDR3700
>>
>> It's only rate configuration option is '300Mbps', which appears to
>> turn on HT40.
>>
>> It is configured for channel 10 (for the packet capture) and actually
>> passes traffic there.  It's just this HT Info thing with (primary-channel ==
>> (real_channel + 4))
>> that seems wrong.  Note that when I had the channel set to 11, it was
>> reporting
>> 15 for the primary channel in the HT info.
>>
>> Looks like a bug in that AP to me...but would be nice if there were a way to
>> work around it, in case others have similar issues.
> 
> Set it to channel 6, then?
> 
> Yeah, I played with Netgear's APs (and D-Link's) for about 3 hours
> before I put them down and never picked them up again.  Performance,
> configuration, reliability, etc., were horrible.  I've found that
> Apple APs work well, but really hostapd offers the best flexibility by
> far.
I think the hardware quality of the WNDR3700 is pretty good. I'm using
it at home regularly (running OpenWrt of course).

- Felix
