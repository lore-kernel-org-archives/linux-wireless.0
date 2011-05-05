Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46430 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab1EEQzx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 12:55:53 -0400
Received: by pvg12 with SMTP id 12so1046278pvg.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 May 2011 09:55:52 -0700 (PDT)
Message-ID: <4DC2D694.3070200@lwfinger.net> (sfid-20110505_185556_402926_68C5381E)
Date: Thu, 05 May 2011 11:55:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH] b43legacy: drop invalid IMCFGLO workaround
References: <1304592364-5075-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1304592364-5075-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/05/2011 05:46 AM, Rafał Miłecki wrote:
> We were performing it on wrong core, it was outdated and is already
> implemented in ssb.
>
> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
> ---
>   drivers/net/wireless/b43legacy/main.c |   32 --------------------------------
>   1 files changed, 0 insertions(+), 32 deletions(-)

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

and an ACK, of course.

Larry

