Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3113 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab1KNKNw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 05:13:52 -0500
Message-ID: <4EC0E9D7.7080304@broadcom.com> (sfid-20111114_111413_857371_C5172C49)
Date: Mon, 14 Nov 2011 11:13:43 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Joe Perches" <joe@perches.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcmsmac: Use current logging styles
References: <1321213264.15834.4.camel@Joe-Laptop>
In-Reply-To: <1321213264.15834.4.camel@Joe-Laptop>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/13/2011 08:41 PM, Joe Perches wrote:
> Add and use pr_fmt and pr_<level>
> Remove useless double parentheses from macros.
> Remove function names from format strings, add to pr_debug use.
> Coalesce formats.
> Remove uncompileable undeclared variable in a DMA_NONE use.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   14 +-
>  drivers/net/wireless/brcm80211/brcmsmac/dma.c     |  145 ++++++++++-----------
>  2 files changed, 80 insertions(+), 79 deletions(-)

Thanks for the service.

Acked-by: Arend van Spriel <arend@broadcom.com>

Gr. AvS


