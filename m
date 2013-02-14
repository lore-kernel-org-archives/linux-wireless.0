Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4852 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932509Ab3BNT4h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 14:56:37 -0500
Message-ID: <511D416C.5070802@broadcom.com> (sfid-20130214_205643_086053_806D424D)
Date: Thu, 14 Feb 2013 20:56:28 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Joe Perches" <joe@perches.com>
cc: "Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
	brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] brcmsmac: Remove unnecessary memset casts
References: <d9d111bab5b3186e858c9e85849a2ec61a7451f3.1360805256.git.joe@perches.com>
 <6b2fcef4f4983542d3fd08005cfe06d7cd82e97e.1360805256.git.joe@perches.com>
In-Reply-To: <6b2fcef4f4983542d3fd08005cfe06d7cd82e97e.1360805256.git.joe@perches.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/14/2013 02:33 AM, Joe Perches wrote:
> Remove the casts of the first argument of memset.
> 
> Neaten the style by using the sizeof the actual variable
> being memset not the sizeof the type of variable.

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/main.c | 23 ++++++++++-------------
>  1 file changed, 10 insertions(+), 13 deletions(-)

For new code we try to stick to that style. Thanks for going through the
existing code.

Gr. AvS

