Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:45823 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbYELSFx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 14:05:53 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>, Helmut Schaa <hschaa@suse.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH/RFC v2] mac80211: fix association with some APs
References: <200805081030.57966.hschaa@suse.de>
	<200805081334.07599.hschaa@suse.de>
	<1210246602.3547.45.camel@johannes.berg>
	<1ba2fa240805081445p4fb5e47cvf2743a868c7887ae@mail.gmail.com>
	<87ej8bykp9.fsf@nokia.com> <1210328819.3547.90.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 12 May 2008 21:04:48 +0300
In-Reply-To: <1210328819.3547.90.camel@johannes.berg> (ext Johannes Berg's message of "Fri\, 09 May 2008 12\:26\:59 +0200")
Message-ID: <87ve1j9z5r.fsf@nokia.com> (sfid-20080512_200610_695182_6B1EB2CB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> Most probably this isn't the only AP which has a similar bug, so it's
>> better to add a workaround anyway. Let's just hope that it doesn't
>> create any regressions.
>
> Speaking of which, what about the Nokia AP bug that cx3110x works
> around? :)

Hah hah, I had forgotten that one altogether :) I don't think we want
to take that route, that is enabling workarounds for APs based on
BSSID. That's going to be a maintainance nightmare in the long run, at
least in my opinion.

We should have one A032 in our office somewhere, I'll try to find it
and see how b43 works with it.

(For others wondering what we are talking about: Nokia 770/N800/N810
products enable long slot time when associating to Nokia A032 AP to
workaround a bug in the AP.)

-- 
Kalle Valo
