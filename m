Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:32360 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab0JMNCM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 09:02:12 -0400
Subject: Re: [PATCH v2 1/4] wl1271: TX aggregation optimization
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Ido Yariv <ido@wizery.com>
Cc: "Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1286873633-10080-2-git-send-email-ido@wizery.com>
References: <1286873633-10080-1-git-send-email-ido@wizery.com>
	 <1286873633-10080-2-git-send-email-ido@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Oct 2010 14:10:35 +0300
Message-ID: <1286881835.11177.493.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-12 at 10:53 +0200, ext Ido Yariv wrote:
> In case the aggregation buffer is too small to hold all available packets,
> the buffer is transferred to the FW and no more packets are aggregated.
> Although there may be enough available TX blocks, no additional packets will
> be handled by the current TX work.
> 
> Fix this by flushing the aggregation buffer when it's full, and continue
> transferring packets as long as there are enough available TX blocks.
> 
> Signed-off-by: Ido Yariv <ido@wizery.com>
> ---
>  drivers/net/wireless/wl12xx/wl1271_tx.c |   27 +++++++++++++++++++--------
>  1 files changed, 19 insertions(+), 8 deletions(-)
> 

Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>

-Juuso

