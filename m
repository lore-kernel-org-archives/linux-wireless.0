Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:42762 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbYKDHNk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 02:13:40 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	tim.gardner@canonical.com, mick@madwifi.org,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: wireless-testing commit eb9d4e8399181357cb6f6625ba7f849987432c6c causes stalls
References: <4908B754.1050400@tpi.com>
	<40f31dec0811020132o640afa49u56791b4122013463@mail.gmail.com>
	<40f31dec0811020110t6ec94c57gd91adc44f759bf45@mail.gmail.com>
	<20081102184146.GA6065@hash.localnet>
	<43e72e890811021249x6047b38do5d7ead10fe4098e7@mail.gmail.com>
	<1225696692.3619.18.camel@johannes.berg>
	<43e72e890811022329g510a280wfd033538ee9b8c17@mail.gmail.com>
	<1225697686.3619.25.camel@johannes.berg>
	<43e72e890811022351m2c03e0b4g2a67a70cd6a7bd3c@mail.gmail.com>
	<1225698867.3619.31.camel@johannes.berg>
	<43e72e890811030001x7a3b166am440873fcf2c143d4@mail.gmail.com>
	<1225699482.3619.34.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 04 Nov 2008 09:12:41 +0200
In-Reply-To: <1225699482.3619.34.camel@johannes.berg> (ext Johannes Berg's message of "Mon\, 03 Nov 2008 09\:04\:42 +0100")
Message-ID: <87ljw0arrq.fsf@nokia.com> (sfid-20081104_081344_850935_47938619)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> > Also,
>> > that's a bad thing to do in userspace, imho.
>> 
>> What should we do with these rare failures then?
>
> print an error message? ignore them? try again?

I would say that try few (three?) times and if it still fails, restart
firmware and push the same settings again to the firmware. There's
very little that mac80211 could do here, driver has to make the
decisions in case like this.

-- 
Kalle Valo
