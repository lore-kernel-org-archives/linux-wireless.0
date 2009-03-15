Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:19333 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbZCOGwv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2009 02:52:51 -0400
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <j@w1.fi>
Subject: Re: [RFC PATCH v2 2/4] mac80211: track beacons separately from the rx 	path activity
References: <20090314171234.11126.21125.stgit@tikku>
	<20090314171438.11126.30330.stgit@tikku>
	<43e72e890903141245k46f4dd4co6a33b45b82e9098a@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sun, 15 Mar 2009 08:52:15 +0200
In-Reply-To: <43e72e890903141245k46f4dd4co6a33b45b82e9098a@mail.gmail.com> (ext Luis R. Rodriguez's message of "Sat\, 14 Mar 2009 20\:45\:12 +0100")
Message-ID: <87vdqb1dnk.fsf@nokia.com> (sfid-20090315_075253_604516_E1124EDE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <lrodriguez@atheros.com> writes:

> On Sat, Mar 14, 2009 at 10:14 AM, Kalle Valo <kalle.valo@nokia.com> wrote:
>> Separate beacon and rx path tracking in preparation for the beacon filtering
>> support. At the same time change ieee80211_associated() to look a bit simpler.
>>
>> Probe requests are now sent only after IEEE80211_PROBE_IDLE_TIME, which
>> is now set to 60 seconds.
>>
>> Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
>
> Can this be split into 3 separate patches, to make the one with the
> actual functional changes easier to review. One is the making of
> ieee80211_associated() look easier, the other the rename, and lastly
> the actual functional changes. When reviewing the commit log it would
> then be easier to see what was done.

Is it really worth the trouble? The patch is relatively small so
spotting the changes shouldn't be that difficult.

-- 
Kalle Valo
