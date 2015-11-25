Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36030 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbbKYJXE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 04:23:04 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: wireless-testing repo
References: <5652F62A.4000109@broadcom.com>
	<1448278260.5792.1.camel@sipsolutions.net>
	<5652FAB5.8030708@broadcom.com> <20151123160159.GA3755@tuxdriver.com>
	<20151123164640.GA4037@localhost>
Date: Wed, 25 Nov 2015 11:22:56 +0200
In-Reply-To: <20151123164640.GA4037@localhost> (Bob Copeland's message of
	"Mon, 23 Nov 2015 11:46:40 -0500")
Message-ID: <87a8q2ph5b.fsf@kamboji.qca.qualcomm.com> (sfid-20151125_102311_892738_2EF4E852)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> On Mon, Nov 23, 2015 at 11:02:00AM -0500, John W. Linville wrote:
>> > We have some setups running on wl-testing kernel and some running distro
>> > kernel using backports.
>> 
>> I believe the Bob Copeland is considering taking on this mantle...
>
> "a" Bob Copeland :)
>
> Yeah, I would be game for maintaining this for a while -- I've scripted
> a bit of it and have a practice tree over here, although of course it
> should be on kernel.org when for reals:
>
>     https://github.com/bcopeland/wireless-testing-testing
>
> But if maintenance becomes a burden there's no reason we couldn't spread
> the load.

I think it would be a good idea to have a shared "wireless" directory
for the wireless-testing, similarly like linux-firmware.git has. That
way the location doesn't change if the maintainer changes or if we have
more than one maintainer.

And I can act as a backup for Bob whenever he is too busy or offline.

-- 
Kalle Valo
