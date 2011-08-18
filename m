Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:33509 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab1HRHwB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Aug 2011 03:52:01 -0400
Subject: Re: [PATCH] Add uevent to bcma bus, to autoload drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Date: Thu, 18 Aug 2011 08:51:36 +0100
In-Reply-To: <CACna6rzQmEE-EF+7tvQ8vkwp9bYwWMkna3UHw8ym7PmjKWWQTQ@mail.gmail.com>
References: <4E3420E9.6080603@lwfinger.net>
	 <CACna6ryErHY+OyAnvc9+MYArb5mXpSdadOPADsQOBz796UqSUw@mail.gmail.com>
	 <1313617419.3990.134.camel@shinybook.infradead.org>
	 <CACna6rzQmEE-EF+7tvQ8vkwp9bYwWMkna3UHw8ym7PmjKWWQTQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1313653897.13224.4.camel@shinybook.infradead.org> (sfid-20110818_095206_353158_0A3AA1D1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-08-18 at 08:46 +0200, Rafał Miłecki wrote:
> 
> Tested on my BCM43224, thanks a lot! :)
> 
> Acked-by: Rafał Miłecki <zajec5@gmail.com>
> 
> You didn't send this directly to John, not sure if he will pick it up.
> 
> Do you think this should go for 3.1? With this patch ppl will directly
> see interface is present and will just use it or see error about
> firmware in dmesg. Without the patch, person just have to know b43 is
> supposed to support his card. 

Yes, it should go in for 3.1.

I wasn't really expecting John to pick it up. You are the maintainer of
drivers/bcma, so I'd expect to send it to *you*. Many maintainers would
be unhappy at patches being sent upstream and bypassing them. Normally
I'd expect you to pick up the patch and add it to your tree/queue with
your own signed-off-by, and for it to go upstream that way.

Of course, I'm happy to send it on directly if that's what you prefer.

-- 
dwmw2

