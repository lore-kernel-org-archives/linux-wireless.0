Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:43873 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754933Ab2BOK3s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 05:29:48 -0500
Message-ID: <1329301782.19569.49.camel@cumari> (sfid-20120215_112953_018676_8FD4E618)
Subject: Re: [patch] wl12xx: remove some dead code in wl1271_plt_init()
From: Luciano Coelho <coelho@ti.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Shahar Levi <shahar_levi@ti.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Wed, 15 Feb 2012 12:29:42 +0200
In-Reply-To: <20120208092004.GB6554@elgon.mountain>
References: <20120208092004.GB6554@elgon.mountain>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-02-08 at 12:20 +0300, Dan Carpenter wrote: 
> "ret" has already been checked at this point, and we don't need to check
> it again.  This was left around from a previous patch 49d750ca14
> "wl12xx: 1281/1283 support - New radio structs and functions".
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.  Thanks, Dan!

-- 
Cheers,
Luca.

