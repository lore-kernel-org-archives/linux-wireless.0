Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:41674 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758410Ab3IBOP5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Sep 2013 10:15:57 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Joe Perches <joe@perches.com>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
	linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org
Subject: Re: [PATCH v2 13/16] wcn36xx: add wcn36xx.h
References: <1377248299-21007-1-git-send-email-k.eugene.e@gmail.com>
	<1377248299-21007-14-git-send-email-k.eugene.e@gmail.com>
	<1377298929.2816.15.camel@joe-AO722>
Date: Mon, 02 Sep 2013 17:15:55 +0300
In-Reply-To: <1377298929.2816.15.camel@joe-AO722> (Joe Perches's message of
	"Fri, 23 Aug 2013 16:02:09 -0700")
Message-ID: <87ioyjux5w.fsf@purkki.adurom.net> (sfid-20130902_161607_857384_40E3A401)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

>> +#define wcn36xx_dbg(mask, fmt, arg...) do {			\
>> +	if (debug_mask & mask)					\
>> +		printk(KERN_DEBUG pr_fmt(fmt), ##arg);	\
>> +} while (0)
>
> And maybe this one using pr_debug so dynamic_debug
> can work too.

Please, no dynamic_debug. It's useless on a wifi driver.

-- 
Kalle Valo
