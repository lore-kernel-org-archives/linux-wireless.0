Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6979 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536Ab1LNSl1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 13:41:27 -0500
Message-ID: <4EE8EDBE.1040504@qca.qualcomm.com> (sfid-20111214_194131_464687_E2D673A9)
Date: Wed, 14 Dec 2011 20:41:02 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <ryanhsu@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 1/1] ath6kl: Support different uart_tx pin and refclk
 configuration
References: <1323767467-5952-1-git-send-email-ryanhsu@qca.qualcomm.com>
In-Reply-To: <1323767467-5952-1-git-send-email-ryanhsu@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/13/2011 11:11 AM, ryanhsu@qca.qualcomm.com wrote:
> From: Ryan Hsu <ryanhsu@qca.qualcomm.com>
> 
>     AR6003 family use uart_tx=8 and refclk=26Mhz by default, and AR6004 family
>     uses different uart_tx pin and could also support various xtal source,
>     moves these per hw configuration.
> 
> Signed-off-by: Ryan Hsu <ryanhsu@qca.qualcomm.com>

Thanks, applied.

Kalle
