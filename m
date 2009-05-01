Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:61516 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563AbZEAN0p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 May 2009 09:26:45 -0400
Received: by fg-out-1718.google.com with SMTP id d23so60078fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 01 May 2009 06:26:44 -0700 (PDT)
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: chunkeey@web.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Fixes compile error with CONFIG_PM=n
References: <1241176356-27531-1-git-send-email-hauke@hauke-m.de>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 01 May 2009 16:26:42 +0300
In-Reply-To: <1241176356-27531-1-git-send-email-hauke@hauke-m.de> (Hauke Mehrtens's message of "Fri\,  1 May 2009 13\:12\:36 +0200")
Message-ID: <87my9x9cod.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hauke Mehrtens <hauke@hauke-m.de> writes:

> /drivers/net/wireless/p54/p54usb.c: In function 'p54u_probe':
> /drivers/net/wireless/p54/p54usb.c:923: error: 'struct usb_device' has no member named 'reset_resume'
>
> In the struct usb_device the reset_resume attribute is only available when CONFIG_PM is defined.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

About the commit log, the title should contain the component, something
like this:

p54: fix reset_resume compile error with CONFIG_PM=n

Also please line wrap the commit log, 72 chars is a good width.

-- 
Kalle Valo
