Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:36722 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbYLVLVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 06:21:37 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
Subject: Re: new sparse warnings
References: <1229855295.4953.0.camel@johannes>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 22 Dec 2008 13:21:19 +0200
In-Reply-To: <1229855295.4953.0.camel@johannes> (ext Johannes Berg's message of "Sun\, 21 Dec 2008 11\:28\:15 +0100")
Message-ID: <8763lclakw.fsf@nokia.com> (sfid-20081222_122141_118412_A7A5327C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> These showed up in the nightly pull from yesterday:
>

[...]

>> +net/mac80211/util.c:355:6: warning: symbol 'ieee80211_wake_queue_by_reason' was not declared. Should it be static?
>> +net/mac80211/util.c:385:6: warning: symbol 'ieee80211_stop_queue_by_reason' was not declared. Should it be static?

Sorry about that, I'll send a fix later this week.

-- 
Kalle Valo
