Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2402 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab2GCHHC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 03:07:02 -0400
Message-ID: <4FF29A07.9030702@broadcom.com> (sfid-20120703_090709_837946_F4E36A7C)
Date: Tue, 3 Jul 2012 09:06:47 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, brcm80211-dev-list@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 12/18] brcmsmac: add a conditions for core rev 17
 again
References: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
 <1341062181-28071-13-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1341062181-28071-13-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/30/2012 03:16 PM, Hauke Mehrtens wrote:
> This reverts some changes made in this commit:
> commit 7234592364e2efe8b4ac1040c99b1d7ef01cf502
> Author: Roland Vossen <rvossen@broadcom.com>
> Date:   Mon Feb 14 12:16:45 2011 +0100
> 
>     staging: brcm80211: removal of inactive d11 code
> 
> The bcm4716 has a rev 17 wireless core and this condition is needed.
> 
Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/main.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Gr. AvS



