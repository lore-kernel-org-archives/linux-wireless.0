Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3423 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab2GCHJJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 03:09:09 -0400
Message-ID: <4FF29A88.40103@broadcom.com> (sfid-20120703_090912_837707_6A493F79)
Date: Tue, 3 Jul 2012 09:08:56 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, brcm80211-dev-list@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 14/18] brcmsmac: extend xmtfifo_sz array
References: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
 <1341062181-28071-15-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1341062181-28071-15-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/30/2012 03:16 PM, Hauke Mehrtens wrote:
> The xmtfifo_sz array contains the queue sizes for the different core
> revs. This array missed the sizes for the core rev 17 and 28. This
> patch extends the array to also include these sizes and adds a warning
> if no queue size is stored in the array for the given core rev.
> 
Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/main.c |   24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)

Gr. AvS



