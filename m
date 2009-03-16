Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:27455 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531AbZCPMhy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 08:37:54 -0400
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: don't drop null frames during software	scan
References: <20090315200738.17370.29374.stgit@tikku>
	<20090316085741.GA29986@jm.kir.nu> <871vsxve5p.fsf@nokia.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 16 Mar 2009 14:36:46 +0200
In-Reply-To: <871vsxve5p.fsf@nokia.com> (Kalle Valo's message of "Mon\, 16 Mar 2009 14\:35\:30 +0200")
Message-ID: <87wsaptzj5.fsf@nokia.com> (sfid-20090316_133756_296885_7DDC02F2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kalle.valo@nokia.com> writes:

>> so this should not matter much, but the comment could be made more
>> clear about the different needs for nullfunc frames (please also
>> s/null frames/nullfunc frames/) and probe request frames. The former
>> are sent only on the operational channel in the beginning and end of
>> scan while the latter are sent on the channels to be scanned during
>> an active scan.
>
> Should the description be in ieee80211_start_scan() in scan.c? I think
> it would make more sense to have it there instead of tx.c. I can then
> add a reference to the comment above.

Oh yeah, forgot to mention that I'll use the term "nullfunc frame" in
v3.

-- 
Kalle Valo
