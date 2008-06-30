Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4179 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbYF3ORK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 10:17:10 -0400
Date: Mon, 30 Jun 2008 10:03:30 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johan Adolfsson <Johan.Adolfsson@axis.com>
Cc: linux-wireless@vger.kernel.org, "'Dan Williams'" <dcbw@redhat.com>
Subject: Re: [PATCH] Add module parameter to override regioncode on libertas
Message-ID: <20080630140330.GB6864@tuxdriver.com> (sfid-20080630_161715_229192_68B9D8BB)
References: <1214580776.10355.16.camel@localhost.localdomain> <054201c8da7b$b12677e0$0137550a@se.axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <054201c8da7b$b12677e0$0137550a@se.axis.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 30, 2008 at 08:36:56AM +0200, Johan Adolfsson wrote:
> 
> Resending to linux-wireless after positive feedback on libertas-dev.
> 
> Attached is a patch against the 2.6.25 driver that adds a 
> module parameter called "regioncode" to set the region code
> in the libertas driver.
> 
> Hope the format is ok.
> Signed-off-by: Johan.Adolfsson@axis.com

Anyone want to offer an opinion on how this (overriding the region
code from the hardware) differs in effect from the patch that disabled
all regulatory controls on mac80211 devices?

>From what I understand about regulatory practices, it seems
irresponsible to allow a regulatory setting embedded in a device's
ROM to be so easily overridden?

John
-- 
John W. Linville
linville@tuxdriver.com
