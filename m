Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:39011 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560Ab3GTGMS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jul 2013 02:12:18 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cw1200:  Fix incorrect endianness annotation in a header field
References: <1374292945-29753-1-git-send-email-pizza@shaftnet.org>
Date: Sat, 20 Jul 2013 09:12:16 +0300
In-Reply-To: <1374292945-29753-1-git-send-email-pizza@shaftnet.org> (Solomon
	Peachy's message of "Sat, 20 Jul 2013 00:02:25 -0400")
Message-ID: <87fvv9yd33.fsf@purkki.adurom.net> (sfid-20130720_081236_147082_962707C7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Solomon Peachy <pizza@shaftnet.org> writes:

> Note that the driver doesn't directly use this field, but it should be
> correctly defined in any case.
>
> I'd like to see this in 3.11-rc

Comment referring to releases should be after "---" line so that they
don't end up in the commit log.

And besides, I don't think this is important enough for -rc. I doubt
there are users who absolutely need this quickly and this patch can wait
for the next merge window.

> Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
> ---

<--- Add the comment here.

>  drivers/net/wireless/cw1200/wsm.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/cw1200/wsm.h b/drivers/net/wireless/cw1200/wsm.h
> index 7afc613..48086e8 100644
> --- a/drivers/net/wireless/cw1200/wsm.h
> +++ b/drivers/net/wireless/cw1200/wsm.h

-- 
Kalle Valo
