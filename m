Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:42107 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab0EQHrU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 May 2010 03:47:20 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1005152314540.21345@ask.diku.dk>
References: <Pine.LNX.4.64.1005152314540.21345@ask.diku.dk>
Date: Mon, 17 May 2010 10:47:17 +0300
Message-ID: <AANLkTimPDHCFcMruCqNUZKsbvKuszh5gWA052SgaPTkD@mail.gmail.com>
Subject: Re: [PATCH 7/37] drivers/net/wireless/wl12xx: Use kmemdup
From: Kalle Valo <kvalo@adurom.com>
To: Julia Lawall <julia@diku.dk>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 May 2010 00:15, Julia Lawall <julia@diku.dk> wrote:
> From: Julia Lawall <julia@diku.dk>
>
> Use kmemdup when some other buffer is immediately copied into the
> allocated region.

Thanks, looks good to me.

> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Kalle Valo <kvalo@adurom.com>
