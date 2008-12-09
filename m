Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:62650 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbYLIKYl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 05:24:41 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>, Chr <chunkeey@web.de>,
	Tomas Winkler <tomasw@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	Michael Buesch <mb@bu3sch.de>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>
Subject: Re: [RFT] mac80211: clean up set_key callback
References: <1228757035.22164.94.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 09 Dec 2008 12:23:41 +0200
In-Reply-To: <1228757035.22164.94.camel@johannes.berg> (ext Johannes Berg's message of "Mon\, 08 Dec 2008 18\:23\:55 +0100")
Message-ID: <8763lt8x5e.fsf@nokia.com> (sfid-20081209_112446_378391_A31F7A31)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Johannes Berg" <johannes@sipsolutions.net> writes:

> The set_key callback now seems rather odd, passing a MAC address
> instead of a station struct, and a local address instead of a
> vif struct. Change that.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Tested with iwl3945 on Lenove X60s. WEP works fine, I can test TKIP or
AES later if you want.

Tested-by: Kalle Valo <kalle.valo@nokia.com>

-- 
Kalle Valo
