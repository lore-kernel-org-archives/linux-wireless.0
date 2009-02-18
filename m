Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.186]:29922 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbZBRTZN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 14:25:13 -0500
Received: by fk-out-0910.google.com with SMTP id f33so46986fkf.5
        for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2009 11:25:12 -0800 (PST)
To: Jason Andryuk <jandryuk@gmail.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] at76c50x-usb: clean up DMA on stack
References: <c4d76b3b0902151837o797d850ajb883ce98338aa8a1@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 18 Feb 2009 21:25:08 +0200
In-Reply-To: <c4d76b3b0902151837o797d850ajb883ce98338aa8a1@mail.gmail.com> (Jason Andryuk's message of "Sun\, 15 Feb 2009 21\:37\:35 -0500")
Message-ID: <87prhfzgx7.fsf@litku.valot.fi> (sfid-20090218_202519_181804_56AC02E2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jason Andryuk <jandryuk@gmail.com> writes:

> cleanup dma on stack issues
>
> - no DMA on stack
> - cleanup unclear endianness issue
>
> Corrected version of Oliver Neukum's original patch for at76_usb

Thanks, but the patch seems to be corrupted:

patching file drivers/net/wireless/at76c50x-usb.c
Hunk #1 FAILED at 580.
patch: **** malformed patch at line 90: *udev, u16 mib, void *buf,

Can you resend, please?

-- 
Kalle Valo
