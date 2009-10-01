Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:50538 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbZJAOYN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2009 10:24:13 -0400
To: Michael Buesch <mb@bu3sch.de>
Cc: David Miller <davem@davemloft.net>, oliver@hartkopp.net,
	johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: fix NOHZ: local_softirq_pending 08
References: <1254324077.3959.7.camel@johannes.local>
	<4AC3A0F1.3060306@hartkopp.net>
	<20090930.163333.234658158.davem@davemloft.net>
	<200910011604.42916.mb@bu3sch.de>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 01 Oct 2009 17:24:13 +0300
In-Reply-To: <200910011604.42916.mb@bu3sch.de> (Michael Buesch's message of "Thu\, 1 Oct 2009 16\:04\:40 +0200")
Message-ID: <87bpkrqjjm.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch <mb@bu3sch.de> writes:

> On Thursday 01 October 2009 01:33:33 David Miller wrote:
>
>> I'm not applying this until all of these details are sorted out 
>
> John, please apply my fix to wireless-testing to get rid of the
> regression. You can revert it later, if there's a better fix
> available.

I agree, please take Michael's patch. It's trivial to change mac80211
part whenever there's better support available.

But I don't think this is a regression because I see the bug also with
2.6.28, most probably it has been in mac80211 forever. But it's still
a bug which needs to be fixed.

-- 
Kalle Valo
