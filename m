Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:51691 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbZGaGYW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 02:24:22 -0400
Received: by bwz19 with SMTP id 19so1015455bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 23:24:22 -0700 (PDT)
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] at76c50x-usb: remove unneeded flush_workqueue() at usb disconnect
References: <1248902442-14621-1-git-send-email-lrodriguez@atheros.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 31 Jul 2009 09:24:19 +0300
In-Reply-To: <1248902442-14621-1-git-send-email-lrodriguez@atheros.com> (Luis R. Rodriguez's message of "Wed\, 29 Jul 2009 14\:20\:41 -0700")
Message-ID: <87ws5pnze4.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <lrodriguez@Atheros.com> writes:

> This driver only uses the mac80211 workqueue and mac80211 requires us to
> cancel all work at driver stop. Since we now have the cancels in the right
> places at stop() we really don't need to flush the mac80211 workqueue so
> remove it.
>
> Cc: Kalle Valo <kalle.valo@iki.fi>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Kalle Valo <kalle.valo@iki.fi>

But I only saw patch 1/2, was there also 2/2?

-- 
Kalle Valo
