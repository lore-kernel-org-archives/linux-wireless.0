Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam01on0088.outbound.protection.outlook.com ([104.47.34.88]:61114
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752780AbdKBKbZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Nov 2017 06:31:25 -0400
Date: Thu, 2 Nov 2017 13:31:07 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: igor.mitsyanko.os@quantenna.com
Cc: linux-wireless@vger.kernel.org, vulyanov@quantenna.com,
        johannes@sipsolutions.net
Subject: Re: [PATCH V2 9/9] qtnfmac: pass all CONNECT cmd params to wireless
 card for processing
Message-ID: <20171102103103.ewmrkhl26f3k2c5a@bars> (sfid-20171102_113129_692393_9879F6B5)
References: <20171031010455.27772-1-igor.mitsyanko.os@quantenna.com>
 <20171031010455.27772-10-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171031010455.27772-10-igor.mitsyanko.os@quantenna.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> 
> Specifically, following parameters are needed for wireless device
> configuration but were not available to it before:
> - HT/VHT capabilities and capabilities masks.
> - full channel info (not just IEEE number)
> - BSSID hint
> - previous BSSID for reassoc request
> 
> Move Management Frame Protection setting from common encr info
> structure into STA-specific .connect command parameters.
> 
> Make sure that all new qlink structure definitions are alignment-safe.
> 
> Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

for the whole patch set...

Regards,
Sergey
