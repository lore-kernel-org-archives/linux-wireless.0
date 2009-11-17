Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:61464 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbZKQQj0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 11:39:26 -0500
Received: by iwn8 with SMTP id 8so134391iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2009 08:39:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1803.194.45.26.221.1258473872.squirrel@webmail.madwifi-project.org>
References: <2205.95.222.251.107.1258282369.squirrel@webmail.otaku42.de>
	<43e72e890911161701p61d0db5ag25a1459f900b3ab7@mail.gmail.com>
	<1803.194.45.26.221.1258473872.squirrel@webmail.madwifi-project.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 17 Nov 2009 08:38:36 -0800
Message-ID: <43e72e890911170838g26172725ga4a843dc5292c29f@mail.gmail.com>
Subject: Re: [Madwifi-devel] Survey: What are you using MadWifi for, and why?
To: Michael Renzmann <mrenzmann@madwifi-project.org>
Cc: madwifi-devel@lists.sourceforge.net,
	madwifi-users@lists.sourceforge.net,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 17, 2009 at 8:04 AM, Michael Renzmann
<mrenzmann@madwifi-project.org> wrote:
> [Removed linux-kernel from CC, having this discussion on three mailing
> lists is more than enough]
>
> Hi Luis.
>
> Luis R. Rodriguez wrote:
>> So some sort of survey on this on madwifi-devel is not fair or just
>> to ath5k/ath9k as the only thing it would bring out is those romantics
>> still reading madwifi-devel due to some sort of attachment to it.
>
> I did ask on madwifi-devel and madwifi-users because these are the lists
> where we can reach those who still stick to MadWifi. The whole idea of the
> survey is to learn about their reasons, to find out what exactly prevents
> them from switching to ath[59]k. Thus it was a natural and intentional
> choice - where else would you have asked these questions?

My point was that there are already hundreds of users already on ath5k
and ath9k and that obviously you will get a biased view of MadWifi /
ath5k situation (I don't consider MadWifi any type of alternative to
ath9k).

You started with:

"As you might have noticed, there currently is a discussion [1] going on
about the future directions of the MadWifi project, including a decision
how to deal with MadWifi driver. It turns out that there are pretty
contrary positions in this regard: some would like to see MadWifi being
dumped completely as soon as possible, others would prefer to continue
development and even implement new features.

What do others think?
"

This alone is an invitation for discussion between MadWifi and ath5k
as supported drivers. Keeping this conversation to madwifi-* lists is
not doing justice to the enhancements made to ath5k so far -- or
ath9k.

That was my point.

> I disagree about your point on fairness. The survey will hopefully result
> in information that we don't seem to have so far, helping those who
> actively work on ath[59]k to determine which features the users are
> missing in both drivers. This survey is working *towards* ath[59]k, not
> against them.

That's not what the above read to me as.

>> Madwifi's future as a Linux driver does not depend on what users wish
>> would happen on a legacy driver due to romantic experiences with it
>> with extensive features and its history.
>
> The development of any software should happen with the user's needs and
> requirements in mind

Note I didn't say otherwise.

>, since otherwise that software won't have users and
> all effort spent on the development is a waste. Just doing development
> "the right way" does not guarantee that the result of such development is
> what users actually need and can work with. That's probably especially
> true if one intends to replace an established software by another one.

This is missing the point I was trying to make which is that MadWifi
future will not depend on what knobs or how much fun users would have
had with MadWifi. Madwifi's future is simply abandonment and
maintenance mode. I don't need a crystal ball for this, its just
trying to illustrate the point that a driver not upstream is a waste
of time.

> Again: there must be reasons why a significant amount of MadWifi users
> didn't switch to ath[59]k yet

MadWifi is in no way any type of replacement for ath9k. If anything
its an alternative legacy driver and base model driver for ath5k.

> and we don't seem to have exact ideas what
> these reasons are.

Well to me they are clear and I don't need a survey to understand
this. ath5k currently lacks:

  * DFS
  * Multi-BSS AP functionality
  * Roaming
  * ANI

Anyone needing these features are out of luck right now with ath5k,
and those that would be out of luck probably would end up using
openwrt anyway and that driver is maintained.

> Listening to these user to see what can be done to make
> them *want* to switch appears like a good idea to me.

My goal is not to force anyone's arm to switch -- I want to focus on
getting things done so that a question does not have to be asked,
instead the answer would be implicit.

> At least it's better than plainly putting them off with the "take it or leave it,
> romantics!"-like approach

But that's the truth. Users of a MadWifi driver for AP mode support
would likely use openwrt, and that has proper support, users who don't
want to deal with out-of-kernel drivers simply won't even touch
MadWifi. Madwifi-devel lacks proper attention and its no surprise, it
was bound to happen, so someone hoping for something else is a
romantic in my mind.

> you (being an Atheros employee) promote despite the fact that those who
> "leave it" may reconsider their decision for Atheros-based equipment.

ath5k is for those who wanted to leave it ages ago and didn't need an
explanation why that was a better path, all I can do is try to create
awareness and speak bluntly about the reality of the situation.
MadWifi development is not going to be kicked up, you won't get better
support, the sooner users realize that the better.

  Luis
