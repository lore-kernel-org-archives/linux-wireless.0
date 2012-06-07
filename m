Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3692 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab2FGUM3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 16:12:29 -0400
Message-ID: <4FD10B1C.4060702@broadcom.com> (sfid-20120607_221232_658445_679416A1)
Date: Thu, 7 Jun 2012 22:12:12 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 02/18] brcmsmac: remove PCI_FORCEHT() makro
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
 <1338937641-8519-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1338937641-8519-3-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
> The BCM4716 is a SoC and does not have a PCI client interface, so this
> condition is never true.

This patch and the first one in the series use the word 'makro' instead
of 'macro'. Probably your native language seeping through ;-)

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   19 -------------------
>  1 file changed, 19 deletions(-)

Gr. AvS

