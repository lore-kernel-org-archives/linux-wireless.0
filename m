Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60217 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab0BOTpk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 14:45:40 -0500
Date: Mon, 15 Feb 2010 14:30:43 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 01/11] b43: N-PHY: add some registers and structs
	definitions
Message-ID: <20100215193042.GA10665@tuxdriver.com>
References: <1265745883-3392-2-git-send-email-zajec5@gmail.com> <201002100002.11369.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <201002100002.11369.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 10, 2010 at 12:02:11AM +0100, Michael Buesch wrote:
> On Tuesday 09 February 2010 21:04:33 Rafał Miłecki wrote:
> > +#define B43_MMIO_PSM_PHY_HDR		0x492	/* programmable state machine */
> 
> The comment doesn't make a lot of sense.
> In case you don't know, the PSM is the part of the hardware
> that executes the firmware.

Rafał,

Are you going to repost this series and/or respond to Michael's
comments?  I tried to apply some of the ones Michael didn't comment
upon, but they seem to depend on the ones in question.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
