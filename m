Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:51731 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbaLWKvE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 05:51:04 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] ipw2200: select CFG80211_WEXT
References: <1419271817.2317.12.camel@tiscali.nl>
	<871tnqhn7j.fsf@kamboji.qca.qualcomm.com>
	<1419330055.30945.76.camel@x220>
Date: Tue, 23 Dec 2014 12:50:54 +0200
In-Reply-To: <1419330055.30945.76.camel@x220> (Paul Bolle's message of "Tue,
	23 Dec 2014 11:20:55 +0100")
Message-ID: <87sig6ej1t.fsf@kamboji.qca.qualcomm.com> (sfid-20141223_115131_371906_BC447C87)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Paul Bolle <pebolle@tiscali.nl> writes:

> On Tue, 2014-12-23 at 08:52 +0200, Kalle Valo wrote:
>> Paul Bolle <pebolle@tiscali.nl> writes:
>> 
>> > Commit 24a0aa212ee2 ("cfg80211: make WEXT compatibility unselectable")
>> > made it impossible to depend on CFG80211_WEXT. It does still allow to
>> > select that symbol. (Yes, the commit summary is confusing.)
>> >
>> > So make IPW2200 select CFG80211_WEXT, so that the ipw2200 driver can be
>> > built again.
>> 
>> I think the last sentence is a bit misleading (this isn't a compilation
>> error, right?)
>
> No, it's not a compilation error.
>
> The reasoning here is that all code hidden behind a Kconfig symbol that
> cannot be set will, in practice, never be built. Sure, there are hoops
> one can jump through to try to bypass the generated .config, but no one
> should have to do that.
>
>>  and I would like to clarify it like this:
>> 
>> "So make IPW2200 select CFG80211_WEXT, so that the ipw2200 driver can be
>> enabled in config again."
>> 
>> Does that look ok?
>
> I understand the confusion my text might cause, so I'm fine with your
> amendment.

Thanks for checking. I'll modify the commit log and apply it to
wireless-drivers.git.

-- 
Kalle Valo
