Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33739 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112Ab1CRXce (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 19:32:34 -0400
Received: by vxi39 with SMTP id 39so3990688vxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 16:32:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4D83EAF5.7030205@gmail.com>
References: <4D83E3F6.9040202@gmail.com> <AANLkTi=zv377vkyFCoaSvkD1e-Rx+OK1nRMPvyr2wRGM@mail.gmail.com>
 <4D83EAF5.7030205@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 18 Mar 2011 16:32:13 -0700
Message-ID: <AANLkTi=MaT3i4RErVcypCEVsJxJJfo5xcy_VadTh2aTD@mail.gmail.com>
Subject: Re: Google Summer of Code 2011 - The Linux Foundation is Accepted as
 Mentoring Organization
To: Till Kamppeter <till.kamppeter@gmail.com>
Cc: Matt Smith <Matt.Smith@atheros.com>,
	Kevin Hayes <kevin@atheros.com>,
	Jouni Malinen <Jouni.Malinen@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Greg KH <greg@kroah.com>,
	Grant Likely <grant.likely@secretlab.ca>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Driver Backport <lf_driver_backport@lists.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 18, 2011 at 4:29 PM, Till Kamppeter
<till.kamppeter@gmail.com> wrote:
> On 03/19/2011 12:26 AM, Luis R. Rodriguez wrote:
>>
>> So one idea I was thinking about was that of using P2P to enable
>> phones to grant a central box tethering capabilities to their 3G
>> connection, while the central box acts as a regular AP. This can be
>> useful on trains to enable users to share their internet and aggregate
>> their connections together. So the project would consist of the
>> utilities and hooks to get these boxen easily deployed anywhere.
>>
>> Since cell phones tend to beacon on the same channel, channel 6, the
>> central box would only be able to aggregate more than 3G connection by
>> having different phones establish a P2P connection on the same
>> channel. Not sure how many connections this limits us to then. It
>> would also be nice to get the AP to function as a regular AP on
>> something other than channel 6 so I guess we'd need the central box to
>> do P2P with multichannel operation. That support likely won't hit
>> upstream for a while.. so hrmm..
>>
>> Just an idea, maybe next year.
>
> I would simply post it.

Hm, well the technical aspects of supporting such an implementation
would be required upstream first. If I get feedback we can at least do
some minimal 2-cell phone thether sharing setup then likely we can get
someone to work on it. Looking for feedback on this though first.

  Luis
