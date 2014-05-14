Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46015 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbaENPAc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 11:00:32 -0400
Date: Wed, 14 May 2014 10:50:00 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: George Spelvin <linux@horizon.com>
Cc: ulf.hansson@linaro.org, arik@wizery.com, david.gnedt@davizone.at,
	eliad@wizery.com, jan.nikitenko@gmail.com,
	laurent.pinchart+renesas@ideasonboard.com,
	linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-spi@vger.kernel.org, linux-wireless@vger.kernel.org,
	luca@coelho.fi, pavel@ucw.cz, tony@atomide.com
Subject: Re: [PATCH 2/3] drivers/mmc/host/mmc_spi.c: Use
 get/put_unaligned_be32
Message-ID: <20140514144959.GA14183@tuxdriver.com> (sfid-20140514_170051_857816_CC31F3D6)
References: <CAPDyKFo9xZ-z6eM0zG2A+=Bwj0EVyGxm=m28Lh9cHPSB+8qq1w@mail.gmail.com>
 <20140514122357.11052.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140514122357.11052.qmail@ns.horizon.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 14, 2014 at 08:23:57AM -0400, George Spelvin wrote:
> Ulf Hansson wrote:
> > Feel free to take this through the wireless tree as well. I assumes
> > it's that same patchset as the other spi related fixes?
> 
> I'd like to answer, but I'm not sure which "other spi related fixes"
> you're referring to.  If you mean patches 1 and 3 of this series, then
> obviously.  If you mean something else then probably not.
> 
> [PATCH 1/3] lib/crc7: Shift crc7() output left 1 bit
> [PATCH 3/3] drivers/net/wireless/ti/wl*/spi.c: Simplify CRC computation
> 
> 
> As there seems to be no objection to sending the mmc change via the
> wireless tree, are they ready to be queued there?
> 
> The additional reviews are:
> All 3: Reviewed-by: Pavel Machek <pavel@ucw.cz>
> 2/3: Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
> 2/3: Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
> 
> I can resend everything with the additional signoff lines
> if that's easier for you.

I can take them, sure.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
