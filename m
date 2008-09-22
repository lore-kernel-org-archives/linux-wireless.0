Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:50044 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbYIVKhk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 06:37:40 -0400
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John Linville" <linville@tuxdriver.com>
Subject: Re: stlc45xx: mac80211 driver for N800 and N810
References: <877i98iw4h.fsf@nokia.com>
	<1221819119.10419.75.camel@johannes.berg> <87abe3mdu4.fsf@nokia.com>
	<43e72e890809201409h456f189ar2157a1f3167d174f@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 22 Sep 2008 13:37:21 +0300
In-Reply-To: <43e72e890809201409h456f189ar2157a1f3167d174f@mail.gmail.com> (ext Luis R. Rodriguez's message of "Sat\, 20 Sep 2008 14\:09\:57 -0700")
Message-ID: <878wtk31r2.fsf@nokia.com> (sfid-20080922_123744_833046_9D306A79)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez <mcgrof@gmail.com> writes:

> Hey just saw this device supports reporting signal strength in RCPI,
> we'll need to add that flag now,

Nah, I don't think it's worth the trouble.

> or I guess we can keep the dbm as the software can do the direct
> mapping.

I think so too.

> Anyway, cool stuff.

Thanks.

-- 
Kalle Valo
