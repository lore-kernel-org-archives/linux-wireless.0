Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43628 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387933AbeGWKbC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jul 2018 06:31:02 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add a missing break in parse_station_flags
References: <AM5PR0701MB265751E3A716081292C5224FE4450@AM5PR0701MB2657.eurprd07.prod.outlook.com>
Date: Mon, 23 Jul 2018 12:30:41 +0300
In-Reply-To: <AM5PR0701MB265751E3A716081292C5224FE4450@AM5PR0701MB2657.eurprd07.prod.outlook.com>
        (Bernd Edlinger's message of "Sun, 8 Jul 2018 09:57:22 +0000")
Message-ID: <87r2juti2m.fsf@purkki.adurom.net> (sfid-20180723_113104_876299_2FC43B00)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bernd Edlinger <bernd.edlinger@hotmail.de> writes:

> I was looking at usually suppressed gcc warnings,
> [-Wimplicit-fallthrough=] in this case:
>
> The code definitely looks like a break is missing here.
> However I am not able to test the NL80211_IFTYPE_MESH_POINT,
> nor do I actually know what might be :)
> So please use this patch with caution and only if you are
> able to do some testing.
>
> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
> ---
>   net/wireless/nl80211.c | 1 +
>   1 file changed, 1 insertion(+)

You should use prefix "nl80211: " in the title.

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#subject

-- 
Kalle Valo
