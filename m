Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:41873 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab1HSUw0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Aug 2011 16:52:26 -0400
Subject: Re: [PATCH] Add uevent to bcma bus, to autoload drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Date: Fri, 19 Aug 2011 21:52:20 +0100
In-Reply-To: <CACna6rzsKaHYL4aH9=0X+_6Q7j-_5AnHc7KfiQ9_FxSLhqEPBA@mail.gmail.com>
References: <4E3420E9.6080603@lwfinger.net>
	 <CACna6ryErHY+OyAnvc9+MYArb5mXpSdadOPADsQOBz796UqSUw@mail.gmail.com>
	 <1313617419.3990.134.camel@shinybook.infradead.org>
	 <CACna6rzQmEE-EF+7tvQ8vkwp9bYwWMkna3UHw8ym7PmjKWWQTQ@mail.gmail.com>
	 <1313653897.13224.4.camel@shinybook.infradead.org>
	 <CACna6rzsKaHYL4aH9=0X+_6Q7j-_5AnHc7KfiQ9_FxSLhqEPBA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1313787142.6210.9.camel@shinybook.infradead.org> (sfid-20110819_225229_246707_E0D2430A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-08-19 at 22:13 +0200, Rafał Miłecki wrote:
> I can accept sending patch directly to John, if I'm included in CC and
> linux-wireless is included as well.

But if b43 isn't ready for *some* bcma card, so you don't want it
autoloading, then perhaps we might have wanted to remove a MODULE_ALIAS
from b43 to prevent it being autoloaded for just *that* device. Or
something like that. So even for this "obviously correct" patch I'd
rather run it by you first.

-- 
dwmw2

