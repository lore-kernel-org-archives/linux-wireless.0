Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:48631 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab0HPRr5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Aug 2010 13:47:57 -0400
Message-ID: <4C6979CC.80107@adurom.com>
Date: Mon, 16 Aug 2010 20:47:56 +0300
From: Kalle Valo <kvalo@adurom.com>
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/16] drivers/net/wireless/wl12xx: Use available error
 codes
References: <Pine.LNX.4.64.1008161825010.19313@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1008161825010.19313@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/16/2010 07:25 PM, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> In each case, error codes are stored in ret, but the return value is always
> 0.  Return ret instead.

Thanks, looks correct to me.

Acked-by: Kalle Valo <kvalo@adurom.com>

Kalle
