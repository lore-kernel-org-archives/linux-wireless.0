Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:63416 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933112Ab0LUJc6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 04:32:58 -0500
Subject: Re: [PATCH 2/7] wl12xx: remove unnecessary import
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1292893316-26694-3-git-send-email-hauke@hauke-m.de>
References: <1292893316-26694-1-git-send-email-hauke@hauke-m.de>
	 <1292893316-26694-3-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Dec 2010 11:32:43 +0200
Message-ID: <1292923963.19436.11.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-21 at 02:01 +0100, ext Hauke Mehrtens wrote:
> No function declared in gpio.h is used here.
> 
> CC: Luciano Coelho <luciano.coelho@nokia.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---

Acked-by: Luciano Coelho <luciano.coelho@nokia.com>

John, please apply this together with the rest of this set, to keep
things simple.

-- 
Cheers,
Luca.

