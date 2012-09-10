Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4838 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757583Ab2IJM03 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 08:26:29 -0400
Message-ID: <504DDD28.6020804@broadcom.com> (sfid-20120910_142632_830714_E355274B)
Date: Mon, 10 Sep 2012 14:29:28 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Colin King" <colin.king@canonical.com>
cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] brcm80211: fix missing allocation failure check
References: <1347267926-7118-1-git-send-email-colin.king@canonical.com>
In-Reply-To: <1347267926-7118-1-git-send-email-colin.king@canonical.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/10/2012 11:05 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> Check for oobirq_entry allocation failure to avoid
> NULL pointer dereferencing.

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    2 ++
>   1 file changed, 2 insertions(+)

Thanks.

Gr. AvS


