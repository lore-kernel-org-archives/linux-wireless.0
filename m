Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:33007 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbXKYG3Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2007 01:29:24 -0500
To: "ext Michael Wu" <flamingice@sourmilk.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: include MAC timestamp in radiotap header
References: <1195814754.4149.86.camel@johannes.berg>
	<200711240021.12394.flamingice@sourmilk.net>
From: Kalle Valo <Kalle.Valo@nokia.com>
Date: Sun, 25 Nov 2007 08:21:50 +0200
In-Reply-To: <200711240021.12394.flamingice@sourmilk.net> (ext Michael Wu's message of "Sat\, 24 Nov 2007 00\:21\:12 -0500")
Message-ID: <87fxyulu9t.fsf@nokia.com> (sfid-20071125_062940_520902_CDA87249)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"ext Michael Wu" <flamingice@sourmilk.net> writes:

>> This makes mac80211 include the low-level MAC timestamp
>> in the radiotap header.
>>
> No thanks. Not every driver supports reporting the timestamp and supporting 
> timestamp/no timestamp in the default radiotap rx code makes it not so simple 
> anymore.

Having MAC timestamps is very useful when one is debugging low level
problems. I'm currently using madwifi for this but would prefer b43.
How many drivers do not support MAC timestamps? It would be really
shame to loose this functionality.

-- 
Kalle Valo
