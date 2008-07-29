Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:31166 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbYG2Vky (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 17:40:54 -0400
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks rtl8187
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	<48874F09.7060400@lwfinger.net>
	<3ace41890807281939y462c9b91n5fa952e167b6ff8c@mail.gmail.com>
	<200807290021.45400.herton@mandriva.com.br>
	<1217314430.15381.11.camel@johannes.berg>
	<1ba2fa240807290123n7673dbb9m7121c1e76fe57e94@mail.gmail.com>
	<1217320089.15381.25.camel@johannes.berg>
	<1ba2fa240807290138h7deced1cob0836ae3e3c1e71a@mail.gmail.com>
	<1217322974.10489.0.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 30 Jul 2008 00:40:04 +0300
In-Reply-To: <1217322974.10489.0.camel@johannes.berg> (ext Johannes Berg's message of "Tue\, 29 Jul 2008 11\:16\:14 +0200")
Message-ID: <87d4kw4bez.fsf@nokia.com> (sfid-20080729_234058_585152_290F02F5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> I've planned to but I waited for some API design suggestions  you guys
>> will come from OLS but I didn't get much input.
>
> This particular thing I don't remember talking about except that we
> want, when powersave is on, be able to select the powersaving level
> based on information applications attach to their sockets, rather than
> requiring the user to make a guess.

We also talked about first implementing a simple interface to enable
and disable powersave. And also about having a timer which enables
powersave whenever where is no traffic, ie. sort of dynamic powersave.
That's a good enough solution which is still simple to implement.

-- 
Kalle Valo
