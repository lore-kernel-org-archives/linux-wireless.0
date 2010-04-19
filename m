Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:57413 "EHLO purkki.valot.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab0DSHTQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 03:19:16 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: regression: soft lockup with ath9k on master-2010-04-14
References: <87pr20mrez.fsf@purkki.valot.fi>
	<20100415195812.GC3020@tuxdriver.com> <871veclztk.fsf@purkki.valot.fi>
	<1271659397.3873.9.camel@jlt3.sipsolutions.net>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 19 Apr 2010 10:19:14 +0300
In-Reply-To: <1271659397.3873.9.camel@jlt3.sipsolutions.net> (Johannes Berg's message of "Mon\, 19 Apr 2010 08\:43\:17 +0200")
Message-ID: <87wrw3lxjh.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> However that shouldn't be the problem. Or rather, that could be the
> reason you're seeing the problem on this patch, rather than the 098a
> one.
>
> Try the patch below?

Sorry, no luck. Still my laptop freezes.

-- 
Kalle Valo
