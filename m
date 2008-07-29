Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:30047 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbYG2VU5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 17:20:57 -0400
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Herton Ronaldo Krzesinski" <herton@mandriva.com.br>,
	"Hin-Tak Leung" <hintak.leung@gmail.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks rtl8187
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	<48874F09.7060400@lwfinger.net>
	<3ace41890807281939y462c9b91n5fa952e167b6ff8c@mail.gmail.com>
	<200807290021.45400.herton@mandriva.com.br>
	<1217314430.15381.11.camel@johannes.berg>
	<1ba2fa240807290123n7673dbb9m7121c1e76fe57e94@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 30 Jul 2008 00:19:54 +0300
In-Reply-To: <1ba2fa240807290123n7673dbb9m7121c1e76fe57e94@mail.gmail.com> (ext Tomas Winkler's message of "Tue\, 29 Jul 2008 11\:23\:30 +0300")
Message-ID: <874p68l75x.fsf@nokia.com> (sfid-20080729_232101_081283_DBFD451C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler <tomasw@gmail.com> writes:

> On Tue, Jul 29, 2008 at 9:53 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Tue, 2008-07-29 at 00:21 -0300, Herton Ronaldo Krzesinski wrote:
>>
>>> [3] /sbin/iwconfig wlan0 power on
>>
>> I don't think turning on power management (yes, this command is
>> completely misnamed, it turns on power _management_ not the power, you
>> may want "txpower auto") does anything on this chip, does it?
>
> iwconfig power on is not implemented by mac80211 yet. There was one
> patch posted that implements it.

John has already applied Samuel's patch to wireless-testing:

http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commitdiff;h=8f87dd7e540d455f8e7f11478133b85edc969c67

> I wanted to expand it but wireless_tools 29 has a bug in parsing
> this command. It is fixed only in 30.pre6 which is usually not in
> distros.

Could you be more specific, please? We have been using it for few
years now.

-- 
Kalle Valo
