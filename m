Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57898 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab2BFQD7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 11:03:59 -0500
Received: by ghrr11 with SMTP id r11so2613284ghr.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2012 08:03:58 -0800 (PST)
Message-ID: <4F2FF9EB.1020405@lwfinger.net> (sfid-20120206_170403_562782_B33B00C1)
Date: Mon, 06 Feb 2012 10:03:55 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Rick Farina <sidhayn@gmail.com>
CC: mcgrof@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Calling make directly is not permitted
References: <1328542694-20777-1-git-send-email-sidhayn@gmail.com>
In-Reply-To: <1328542694-20777-1-git-send-email-sidhayn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/2012 09:38 AM, Rick Farina wrote:
> make was being called directly, fix to $(MAKE)
>
> Signed-of-By: Rick Farina<sidhayn@gmail.com>
> ---
>   Makefile |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)

In your subject line, please indicate what component is being patched. From the 
context, I think it is compat-wireless, but why should I have to guess?

Larry
