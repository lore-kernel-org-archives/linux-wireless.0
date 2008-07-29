Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:31453 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbYG2Vps (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 17:45:48 -0400
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks rtl8187
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	<3ace41890807281939y462c9b91n5fa952e167b6ff8c@mail.gmail.com>
	<200807290021.45400.herton@mandriva.com.br>
	<1217314430.15381.11.camel@johannes.berg>
	<1ba2fa240807290123n7673dbb9m7121c1e76fe57e94@mail.gmail.com>
	<1217320089.15381.25.camel@johannes.berg>
	<1ba2fa240807290138h7deced1cob0836ae3e3c1e71a@mail.gmail.com>
	<1217322974.10489.0.camel@johannes.berg>
	<1ba2fa240807290226n19ab0944u8e27f40cb688cfcc@mail.gmail.com>
	<1217323749.10489.7.camel@johannes.berg>
	<1ba2fa240807290416l7c489b50yca9efe637895725b@mail.gmail.com>
	<1217330333.10489.17.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 30 Jul 2008 00:44:22 +0300
In-Reply-To: <1217330333.10489.17.camel@johannes.berg> (ext Johannes Berg's message of "Tue\, 29 Jul 2008 13\:18\:53 +0200")
Message-ID: <878wvk4b7t.fsf@nokia.com> (sfid-20080729_234551_572659_82A7C7CB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> What I would actually start with is to get notification about dc or
>> battery supply. I don't think that class
>> implements notification chain though.
>
> That policy is probably just powersave on/off and definitely belongs
> into userland.

I fully agree with Johannes, it belongs to user space. And besides, I
might want to use powersave even when connected to AC.

-- 
Kalle Valo
