Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:50679 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbaEAPBk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2014 11:01:40 -0400
Received: by mail-oa0-f42.google.com with SMTP id i7so3715047oag.1
        for <linux-wireless@vger.kernel.org>; Thu, 01 May 2014 08:01:39 -0700 (PDT)
Message-ID: <536261D1.9070505@lwfinger.net> (sfid-20140501_170208_803490_B12DEB9A)
Date: Thu, 01 May 2014 10:01:37 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Tim Gardner <tim.gardner@canonical.com>,
	Nicolas Vaquero <nicovaq92@hotmail.com>
CC: Sven Eckelmann <sven@narfation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Kernel source
References: <535E7741.1030607@lwfinger.net> <3262959.TlL8alHHte@bentobox> <53610B15.4000607@lwfinger.net> <BLU0-SMTP5388FC10A36BF1D90FE79FA9410@phx.gbl> <5362475C.8040308@canonical.com>
In-Reply-To: <5362475C.8040308@canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/01/2014 08:08 AM, Tim Gardner wrote:
> It looks like there is already a bug report in progress for this:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1289429
>
> I'll attach the patch and have Joe build a test kernel.

Tim,

I agree that #1289429 is this bug. It seems that the problem also happens for 
3.5.0-48-generic. If that is being supported, it also needs this patch.

Larry


