Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4922 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759352Ab3FCRI3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 13:08:29 -0400
Message-ID: <51ACCD36.3050504@broadcom.com> (sfid-20130603_190832_097423_E7B55457)
Date: Mon, 3 Jun 2013 19:07:02 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John Greene" <jogreene@redhat.com>
cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] brcmsmac: Reduce log spam in heavy tx, make err
 print in debug
References: <1370267259-19712-1-git-send-email-jogreene@redhat.com>
In-Reply-To: <1370267259-19712-1-git-send-email-jogreene@redhat.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/03/2013 03:47 PM, John Greene wrote:
> Move message to debug mode to reduce log spam under heavy tx (iperf) load.
> This message prints in ht debug mode only:
> brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel
> possibly 153

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: John Greene <jogreene@redhat.com>
> ---
>   drivers/net/wireless/brcm80211/brcmsmac/ampdu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>

