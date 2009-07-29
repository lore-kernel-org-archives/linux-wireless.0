Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:41088 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbZG2FkC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 01:40:02 -0400
Received: by fxm18 with SMTP id 18so174977fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2009 22:40:01 -0700 (PDT)
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ar76c50x-usb: cancel promisc work during mac80211 stop
References: <1248720984-15922-1-git-send-email-lrodriguez@atheros.com>
	<1248720984-15922-2-git-send-email-lrodriguez@atheros.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 29 Jul 2009 08:39:57 +0300
In-Reply-To: <1248720984-15922-2-git-send-email-lrodriguez@atheros.com> (Luis R. Rodriguez's message of "Mon\, 27 Jul 2009 11\:56\:23 -0700")
Message-ID: <87k51soxn6.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <lrodriguez@Atheros.com> writes:

> We weren't ever cancelling this.
>
> Cc: Kalle Valo <kalle.valo@iki.fi>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Thanks.

Acked-by: Kalle Valo <kalle.valo@iki.fi>

-- 
Kalle Valo
