Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([131.228.20.171]:32639 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084AbXHPFqQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 01:46:16 -0400
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>
Subject: Re: mac80211 AP mode powersaving problems?
References: <1186990509.27916.38.camel@johannes.berg>
From: Kalle Valo <Kalle.Valo@nokia.com>
Date: Thu, 16 Aug 2007 08:43:21 +0300
In-Reply-To: <1186990509.27916.38.camel@johannes.berg> (ext Johannes Berg's message of "Mon\, 13 Aug 2007 09\:35\:09 +0200")
Message-ID: <87lkccf30m.fsf@tikku.osso.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Johannes Berg" <johannes@sipsolutions.net> writes:

> is it possible that something is broken with powersave mode? I frequently
> have connection stalls up to hangs with the N770 that go away when I
> either continually ping from the beginning of the connection or do
> something from the N770 instead of from the laptop that is functioning
> as the AP.

[...]

> I'll keep digging, but if somebody has any idea if/how the powersave
> code works let me know where to look.

One thing which came to my mind is that when Nokia 770 is in PSM it
uses PS-Poll to fetch the frames from AP. Few devices do that, so I
wonder if mac80211 supports that properly?

But I'm just guessing here.

-- 
Kalle Valo
