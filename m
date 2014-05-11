Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36646 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757719AbaEKKdg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 May 2014 06:33:36 -0400
Date: Sun, 11 May 2014 12:33:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: George Spelvin <linux@horizon.com>
Cc: arik@wizery.com, david.gnedt@davizone.at, eliad@wizery.com,
	jan.nikitenko@gmail.com, laurent.pinchart+renesas@ideasonboard.com,
	linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-spi@vger.kernel.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, luca@coelho.fi, tony@atomide.com
Subject: Re: [PATCH 2/3] drivers/mmc/host/mmc_spi.c: Use
 get/put_unaligned_be32
Message-ID: <20140511103327.GB32609@xo-6d-61-c0.localdomain> (sfid-20140511_123340_246560_4556D8B2)
References: <20140511100211.1334.qmail@ns.horizon.com>
 <20140511100502.1491.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140511100502.1491.qmail@ns.horizon.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun 2014-05-11 06:05:02, George Spelvin wrote:
> Very minor source and binary size reduction.
> 
> Signed-off-by: George Spelvin <linux@horizon.com>

Reviewed-by: Pavel Machek <pavel@ucw.cz>
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
