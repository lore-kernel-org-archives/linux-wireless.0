Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:44474 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbZICUVo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2009 16:21:44 -0400
Received: by bwz19 with SMTP id 19so229599bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2009 13:21:45 -0700 (PDT)
To: <gregkh@suse.de>
Cc: greg@kroah.com, linux-wireless@vger.kernel.org
Subject: Re: patch staging-remove-at76_usb-wireless-driver.patch added to gregkh-2.6 tree
References: <12520044192286@kroah.org>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 03 Sep 2009 23:21:43 +0300
In-Reply-To: <12520044192286@kroah.org> (gregkh@suse.de's message of "Thu\, 03 Sep 2009 12\:00\:19 -0700")
Message-ID: <87tyzj93u0.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<gregkh@suse.de> writes:

> From: Greg Kroah-Hartman <gregkh@suse.de>
> Subject: Staging: remove at76_usb wireless driver.
>
> There is already an in-kernel driver for this hardware (since 2.6.30),
> at76c50x-usb, and it supports all of the same devices.  So this driver
> can now be deleted.
>
> Cc: Kalle Valo <kalle.valo@iki.fi> 
> Cc: linux-wireless <linux-wireless@vger.kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Thanks.

Acked-by: Kalle Valo <kalle.valo@iki.fi>

-- 
Kalle Valo
