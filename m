Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1646 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755846Ab2I0Ktz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:49:55 -0400
Message-ID: <50642F48.4060102@broadcom.com> (sfid-20120927_125001_186951_97A7671D)
Date: Thu, 27 Sep 2012 12:49:44 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <dan.carpenter@oracle.com>
cc: "Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] brcmfmac: use kcalloc() to prevent integer overflow
References: <20120926072148.GA3956@elgon.mountain>
In-Reply-To: <20120926072148.GA3956@elgon.mountain>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/26/2012 09:21 AM, Dan Carpenter wrote:
> The multiplication here looks like it could overflow.  I've changed it
> to use kcalloc() to prevent that.
>
Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Only needed in linux-next.  This was added in e58060723c "brcmfmac:
> introduce scheduled scan support".

Better be safe than sorry. Thanks.

Gr. AvS

> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c


