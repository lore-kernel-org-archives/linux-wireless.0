Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:60067 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbYIPKCh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 06:02:37 -0400
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Helmut Schaa <hschaa@suse.de>, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: Re: [RFC] mac80211: notify the user space about low signal quality
References: <200809151416.07552.hschaa@suse.de>
	<200809151634.06448.hschaa@suse.de>
	<1221492529.10177.76.camel@localhost.localdomain>
	<200809151845.35841.hschaa@suse.de>
	<43e72e890809151821h5d40e750q10c78f4d20d27c79@mail.gmail.com>
	<87r67kzf7c.fsf@nokia.com> <1221552727.8916.19.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 16 Sep 2008 11:55:38 +0300
In-Reply-To: <1221552727.8916.19.camel@johannes.berg> (ext Johannes Berg's message of "Tue\, 16 Sep 2008 10\:12\:07 +0200")
Message-ID: <873ak0zcz9.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2008-09-16 at 11:07 +0300, Kalle Valo wrote:
>
>> I definitely want to see this background scan support in Wireless
>> Extensions as well, otherwise it might prevent the real use of the
>> feature.
>
> However, the more feature we keep stuffing into WEXT the less incentive
> is there to actually do something about cfg80211. I'm with Luis here,
> the fact that there are no tools anywhere is because those tools aren't
> really very useful yet, not because it's not possible to get the tools
> in.

I understand yours and Luis' points. But I still think that we should
push cfg80211 acceptance first with the argument of more reliable
method of configure 80211 devices, and only later start adding
cfg80211-only features.

-- 
Kalle Valo
