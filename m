Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39877 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932721Ab1CRXaB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 19:30:01 -0400
Received: by bwz15 with SMTP id 15so3762279bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 16:30:00 -0700 (PDT)
Message-ID: <4D83EAF5.7030205@gmail.com>
Date: Sat, 19 Mar 2011 00:29:57 +0100
From: Till Kamppeter <till.kamppeter@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Matt Smith <Matt.Smith@atheros.com>,
	Kevin Hayes <kevin@atheros.com>,
	Jouni Malinen <Jouni.Malinen@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Greg KH <greg@kroah.com>,
	Grant Likely <grant.likely@secretlab.ca>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Driver Backport <lf_driver_backport@lists.linux-foundation.org>
Subject: Re: Google Summer of Code 2011 - The Linux Foundation is Accepted
 as Mentoring Organization
References: <4D83E3F6.9040202@gmail.com> <AANLkTi=zv377vkyFCoaSvkD1e-Rx+OK1nRMPvyr2wRGM@mail.gmail.com>
In-Reply-To: <AANLkTi=zv377vkyFCoaSvkD1e-Rx+OK1nRMPvyr2wRGM@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/19/2011 12:26 AM, Luis R. Rodriguez wrote:
> So one idea I was thinking about was that of using P2P to enable
> phones to grant a central box tethering capabilities to their 3G
> connection, while the central box acts as a regular AP. This can be
> useful on trains to enable users to share their internet and aggregate
> their connections together. So the project would consist of the
> utilities and hooks to get these boxen easily deployed anywhere.
>
> Since cell phones tend to beacon on the same channel, channel 6, the
> central box would only be able to aggregate more than 3G connection by
> having different phones establish a P2P connection on the same
> channel. Not sure how many connections this limits us to then. It
> would also be nice to get the AP to function as a regular AP on
> something other than channel 6 so I guess we'd need the central box to
> do P2P with multichannel operation. That support likely won't hit
> upstream for a while.. so hrmm..
>
> Just an idea, maybe next year.

I would simply post it.

    Till
