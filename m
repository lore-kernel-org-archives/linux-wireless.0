Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:50483 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab1HONTG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 09:19:06 -0400
Subject: Re: [PATCH 2/3] b43: LCN-PHY: implement disabling radio
From: David Woodhouse <dwmw2@infradead.org>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Date: Mon, 15 Aug 2011 07:18:57 -0600
In-Reply-To: <CA+XFjio4gg5zO-gx+6v2rLGidziNY-rUachmdt02VwE9tX_SWQ@mail.gmail.com>
References: <1313357250-8292-1-git-send-email-zajec5@gmail.com>
	 <1313357250-8292-2-git-send-email-zajec5@gmail.com>
	 <CA+XFjio4gg5zO-gx+6v2rLGidziNY-rUachmdt02VwE9tX_SWQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1313414343.3990.6.camel@shinybook.infradead.org> (sfid-20110815_151912_988263_2BA7C04C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-08-15 at 01:24 +0200, Gábor Stefanik wrote:
> Doesn't brcm80211 support this PHY? (Because then, reverse-engineering
> wl is pointless.)

I'd be great to "clean up" the interface between brcm80211 and its phy
code, so that the phy code can be moved out of drivers/staging. And once
we've done that, we can make b43 use it too.

That way we not only get LCN PHY code, but also hopefully support for
*other* PHYs as and when they are produced.

-- 
dwmw2

