Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:16996 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933382Ab0LUJti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 04:49:38 -0500
Subject: Re: [patch -next] wl12xx: use after free in debug code
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Dan Carpenter <error27@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Shahar Levi <shahar_levi@ti.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <20101221040012.GD1936@bicker>
References: <20101221040012.GD1936@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Dec 2010 11:44:25 +0200
Message-ID: <1292924665.19436.12.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-21 at 07:00 +0300, ext Dan Carpenter wrote:
> If debugging is turned on, then wl1271_dump() dereferences a freed
> variable.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Applied, thank you!


-- 
Cheers,
Luca.

