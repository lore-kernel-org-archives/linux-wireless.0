Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2034 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758666Ab3BNTzL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 14:55:11 -0500
Message-ID: <511D4112.6010908@broadcom.com> (sfid-20130214_205543_687079_F1153A4A)
Date: Thu, 14 Feb 2013 20:54:58 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Joe Perches" <joe@perches.com>
cc: "Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
	brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] brcmsmac: Downgrade d11hdrs_mac80211 error
 messages to warnings.
References: <d9d111bab5b3186e858c9e85849a2ec61a7451f3.1360805256.git.joe@perches.com>
In-Reply-To: <d9d111bab5b3186e858c9e85849a2ec61a7451f3.1360805256.git.joe@perches.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/14/2013 02:33 AM, Joe Perches wrote:
> These messages don't seem to be errors but notifications
> that some attribute isn't quite right.
> 
> Don't mark them as errors.
> 

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/main.c | 29 ++++++++++++--------------
>  1 file changed, 13 insertions(+), 16 deletions(-)


