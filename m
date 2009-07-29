Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f221.google.com ([209.85.218.221]:49658 "EHLO
	mail-bw0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbZG2FlW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 01:41:22 -0400
Received: by bwz21 with SMTP id 21so475718bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2009 22:41:21 -0700 (PDT)
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] at76c50x-usb: cancel scan work at stop callback
References: <1248720984-15922-1-git-send-email-lrodriguez@atheros.com>
	<1248720984-15922-3-git-send-email-lrodriguez@atheros.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 29 Jul 2009 08:41:17 +0300
In-Reply-To: <1248720984-15922-3-git-send-email-lrodriguez@atheros.com> (Luis R. Rodriguez's message of "Mon\, 27 Jul 2009 11\:56\:24 -0700")
Message-ID: <87fxcgoxky.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <lrodriguez@Atheros.com> writes:

> This should fix suspend as mac80211 expects all work queued
> to the mac80211 workqueue to be canceled at driver stop().
>
> Cc: Kalle Valo <kalle.valo@iki.fi>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Indeed, the original implementation doesn't make any sense. Thanks for
looking at at76c50x-usb.

Acked-by: Kalle Valo <kalle.valo@iki.fi>

-- 
Kalle Valo
