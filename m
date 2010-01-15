Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:33320 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab0AOHXR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2010 02:23:17 -0500
Received: by ewy1 with SMTP id 1so496615ewy.28
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jan 2010 23:23:16 -0800 (PST)
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wl1271: remove unused flags
References: <1263338584-27132-1-git-send-email-lrodriguez@atheros.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 15 Jan 2010 09:23:12 +0200
In-Reply-To: <1263338584-27132-1-git-send-email-lrodriguez@atheros.com> (Luis R. Rodriguez's message of "Tue\, 12 Jan 2010 18\:23\:04 -0500")
Message-ID: <87r5prsufz.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <lrodriguez@atheros.com> writes:

> These are unused and as with a previous patch 5ef5da for wl1251
> this removes some other unused flags. the IRQ_MASK specifically
> conflicts with include/pcmcia/cs.h when using compat-wireless.

Thanks, looks good to me.

> Cc: Kalle Valo <kalle.valo@nokia.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Reviewed-by: Kalle Valo <kalle.valo@nokia.com>

-- 
Kalle Valo
