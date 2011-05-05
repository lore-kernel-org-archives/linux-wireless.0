Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51571 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab1EEQ4Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 12:56:25 -0400
Received: by pwi15 with SMTP id 15so1063007pwi.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 May 2011 09:56:25 -0700 (PDT)
Message-ID: <4DC2D6B4.1000403@lwfinger.net> (sfid-20110505_185628_024790_197BF052)
Date: Thu, 05 May 2011 11:56:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH] b43: drop invalid IMCFGLO workaround
References: <1304592352-5042-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1304592352-5042-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/05/2011 05:45 AM, Rafał Miłecki wrote:
> We were performing it on wrong core, it was outdated and is already
> implemented in ssb.
>
> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
> ---
>   drivers/net/wireless/b43/main.c |   28 +---------------------------
>   1 files changed, 1 insertions(+), 27 deletions(-)

ACK.

Larry

