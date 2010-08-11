Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:2392 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004Ab0HKTog (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Aug 2010 15:44:36 -0400
Subject: Re: [PATCH] wireless: revert %pM to %pm conversion
From: Joe Perches <joe@perches.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <201008112131.01906.chunkeey@googlemail.com>
References: <201008112131.01906.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 12:44:33 -0700
Message-ID: <1281555874.3976.51.camel@Joe-Laptop.home>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-08-11 at 21:31 +0200, Christian Lamparter wrote:
> The patch: "drivers/net/wireless: Use wiphy_<level>" not
> only replaced printk(KERN_<level> with wiphy_<level>, but
> also converted some format string characters to lower case.

Thanks Christian.

My fault, sorry.

There are more undesired newly lower cased words in
the original patch.

I now know how that happened.

I lowercased the whole string instead of just the
KERN_<level> part.

I'll fix it and resubmit on top of Christian's patch
unless John wants a single patch.


