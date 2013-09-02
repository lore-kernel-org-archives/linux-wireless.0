Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:42911 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757123Ab3IBRty (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Sep 2013 13:49:54 -0400
Message-ID: <1378144193.1953.88.camel@joe-AO722> (sfid-20130902_194957_650656_BF029B63)
Subject: Re: [PATCH v2 13/16] wcn36xx: add wcn36xx.h
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
	linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org
Date: Mon, 02 Sep 2013 10:49:53 -0700
In-Reply-To: <87ioyjux5w.fsf@purkki.adurom.net>
References: <1377248299-21007-1-git-send-email-k.eugene.e@gmail.com>
	 <1377248299-21007-14-git-send-email-k.eugene.e@gmail.com>
	 <1377298929.2816.15.camel@joe-AO722> <87ioyjux5w.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-09-02 at 17:15 +0300, Kalle Valo wrote:
> Joe Perches <joe@perches.com> writes:
> 
> >> +#define wcn36xx_dbg(mask, fmt, arg...) do {			\
> >> +	if (debug_mask & mask)					\
> >> +		printk(KERN_DEBUG pr_fmt(fmt), ##arg);	\
> >> +} while (0)
> >
> > And maybe this one using pr_debug so dynamic_debug
> > can work too.
> 
> Please, no dynamic_debug. It's useless on a wifi driver.

Why is that?

