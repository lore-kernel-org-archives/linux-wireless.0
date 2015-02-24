Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59192 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbbBXRxU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 12:53:20 -0500
Date: Tue, 24 Feb 2015 12:53:16 -0500
From: Kyle McMartin <kyle@infradead.org>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-firmware@kernel.org, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH] brcm: drop executable from brcmfmac43143-sdio.bin
Message-ID: <20150224175316.GN30928@merlin.infradead.org> (sfid-20150224_185322_931488_DD4C2F79)
References: <1424124587-28065-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1424124587-28065-1-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 16, 2015 at 11:09:47PM +0100, Rafał Miłecki wrote:
> It isn't supposed to be run on host obviously.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Ah, I was working backwards and Marcel sent a patch more recently which
fixed this and a few other files.

Sorry about that -- Kyle

> ---
>  brcm/brcmfmac43143-sdio.bin | Bin
>  1 file changed, 0 insertions(+), 0 deletions(-)
>  mode change 100755 => 100644 brcm/brcmfmac43143-sdio.bin
> 
> diff --git a/brcm/brcmfmac43143-sdio.bin b/brcm/brcmfmac43143-sdio.bin
> old mode 100755
> new mode 100644
> -- 
> 1.8.4.5
> 
> 
