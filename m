Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:37727 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378Ab1FTOmE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 10:42:04 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: dynamic PS - don't enter PS when TX frames are pending
References: <1308425533-20854-1-git-send-email-arik@wizery.com>
	<1308471076.4145.6.camel@jlt3.sipsolutions.net>
	<20110620133535.GA2251@tuxdriver.com>
	<1308578353.4322.8.camel@jlt3.sipsolutions.net>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 20 Jun 2011 17:42:00 +0300
In-Reply-To: <1308578353.4322.8.camel@jlt3.sipsolutions.net> (Johannes Berg's message of "Mon\, 20 Jun 2011 15\:59\:13 +0200")
Message-ID: <87aadc1s5j.fsf@purkki.adurom.net> (sfid-20110620_164208_125453_CC4A264E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> > FWIW, I don't really consider myself maintaining the PS
>> > implementation ;-) I don't understand it and think the code is way too
>> > complex.
>> 
>> Perhaps Kalle can comment?  Or...?
>
> Yeah he's a good candidate :)

Hehe :)

But I agree with Johannes, the powersave in mac80211 is pretty
complex. I lost track of it a long time ago so it's pretty difficult
for me to comment about the patch.

-- 
Kalle Valo
