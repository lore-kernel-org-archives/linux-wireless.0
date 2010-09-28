Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:19220 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab0I1ULg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 16:11:36 -0400
Subject: Re: [PATCH] wl12xx: fix non-wl12xx build scenarios
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Ohad Ben-Cohen <ohad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1285698028-21034-1-git-send-email-ohad@wizery.com>
References: <1285697383.4728.10.camel@powerslave>
	 <1285698028-21034-1-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 23:11:20 +0300
Message-ID: <1285704680.4728.31.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-28 at 20:20 +0200, ext Ohad Ben-Cohen wrote:
> Support building wl1271-equipped boards without building the
> wl1271 driver itself, e.g.:
> 
> CONFIG_MACH_OMAP_ZOOM3=y
> CONFIG_WL12XX is not set
> 
> Reported-by: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---

Thanks.  Applied to the wl12xx tree.

-- 
Cheers,
Luca.

