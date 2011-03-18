Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46962 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757612Ab1CRX0d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 19:26:33 -0400
Received: by vxi39 with SMTP id 39so3988186vxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 16:26:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4D83E3F6.9040202@gmail.com>
References: <4D83E3F6.9040202@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 18 Mar 2011 16:26:12 -0700
Message-ID: <AANLkTi=zv377vkyFCoaSvkD1e-Rx+OK1nRMPvyr2wRGM@mail.gmail.com>
Subject: Re: Google Summer of Code 2011 - The Linux Foundation is Accepted as
 Mentoring Organization
To: Till Kamppeter <till.kamppeter@gmail.com>,
	Matt Smith <Matt.Smith@atheros.com>,
	Kevin Hayes <kevin@atheros.com>,
	Jouni Malinen <Jouni.Malinen@atheros.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Greg KH <greg@kroah.com>,
	Grant Likely <grant.likely@secretlab.ca>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Driver Backport <lf_driver_backport@lists.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 18, 2011 at 4:00 PM, Till Kamppeter
<till.kamppeter@gmail.com> wrote:
> Hi,
>
> the Linux Foundation is accepted as mentoring organization for this year's
> Google Summer of Code. This means that you can again have students working
> on your projects.
>
> Students can apply from March 28 on, so please check your project ideas
> lists on
>
> https://www.linuxfoundation.org/collaborate/workgroups/gsoc/google-summer-code-2011
>
> and
>
> http://wireless.kernel.org/en/developers/GSoC/2011
>
> and add any project ideas which you have for the Google Summer of Code and
> which are not listed yet. You are also welcome to improve the project
> descriptions which are already there and to volunteer as a mentor. Please
> also answer any inquiry of potential students to assure that you get as many
> applications as possible.
>
> If you intend to mentor one or more students this year, please register as
> mentor. To do so, do the following:
>
> 1. Make sure you have a Google account and you are able to log in.
>
> 2. Log in on http://socghop.appspot.com/ with your Google account.
>
> 3. If you have no user profile for the Google Summer of Code yet, create
> one. If you have a user profile already from one of the previous GSoCs,
> reuse this profile.
>
> 4. Under "Programs" -> "GSoC 2011" in the menu on the left you should find
> an entry "Apply to become a Mentor" now. Click it. You will now have to
> select the mentoring organization. It is the Linux Foundation (Link ID:
> "linux_foundation", Short name: LF). After submitting your mentor
> application I will get a notification so that I can approve it. You should
> get a notification that I have approved you. After that you have to fill
> your mentor profile. Only having done so you get a mentor and can assign
> yourself as mentor for one or more students. To make it easier for me to
> recognize your GSoC user name, send me an e-mail when you apply to get a
> mentor.
>
> I hope we will have a great Google Summer of Code 2011.

So one idea I was thinking about was that of using P2P to enable
phones to grant a central box tethering capabilities to their 3G
connection, while the central box acts as a regular AP. This can be
useful on trains to enable users to share their internet and aggregate
their connections together. So the project would consist of the
utilities and hooks to get these boxen easily deployed anywhere.

Since cell phones tend to beacon on the same channel, channel 6, the
central box would only be able to aggregate more than 3G connection by
having different phones establish a P2P connection on the same
channel. Not sure how many connections this limits us to then. It
would also be nice to get the AP to function as a regular AP on
something other than channel 6 so I guess we'd need the central box to
do P2P with multichannel operation. That support likely won't hit
upstream for a while.. so hrmm..

Just an idea, maybe next year.

  Luis
