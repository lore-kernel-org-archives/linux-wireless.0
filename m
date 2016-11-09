Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58308 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752027AbcKIBaw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Nov 2016 20:30:52 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: proto: add callback for queuing TX data
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160926215144.9923-1-zajec5@gmail.com>
References: <20160926215144.9923-1-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Message-Id: <20161109013051.EB9726135C@smtp.codeaurora.org> (sfid-20161109_023115_201751_514A0F0D)
Date: Wed,  9 Nov 2016 01:30:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> So far our core code was calling brcmf_fws_process_skb which wasn't
> a proper thing to do. If case of devices using msgbuf protocol fwsignal
> shouldn't be used. It was an unnecessary extra layer simply calling
> a protocol specifix txdata function.
> 
> Please note we already have txdata callback, but it's used for calls
> between bcdc and fwsignal so it couldn't be simply used there.
> 
> This makes core code more generic (instead of bcdc/fwsignal specific).
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Patch applied to wireless-drivers-next.git, thanks.

b073ac1fcf42 brcmfmac: proto: add callback for queuing TX data

-- 
https://patchwork.kernel.org/patch/9351305/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
