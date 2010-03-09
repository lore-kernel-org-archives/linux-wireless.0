Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:50648 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803Ab0CIUqA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 15:46:00 -0500
Received: by ewy8 with SMTP id 8so964406ewy.28
        for <linux-wireless@vger.kernel.org>; Tue, 09 Mar 2010 12:45:58 -0800 (PST)
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 20/22] wl1271: Clean up TX security sequence number handling
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
	<1266820722-20202-21-git-send-email-juuso.oikarinen@nokia.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 09 Mar 2010 22:45:53 +0200
In-Reply-To: <1266820722-20202-21-git-send-email-juuso.oikarinen@nokia.com> (Juuso Oikarinen's message of "Mon\, 22 Feb 2010 08\:38\:40 +0200")
Message-ID: <878wa1dy0u.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Juuso Oikarinen <juuso.oikarinen@nokia.com> writes:

> Instead of managing the TX security sequence number as two variables, use
> one 64 bit variable. This greatly simplifies the handling of the number.

[...]

> -	u16 tx_security_seq_16;
> -	u32 tx_security_seq_32;
> +	s64 tx_security_seq;

I'm curious, why s64 and not u64? I'm sure there's a good reason, I
just wasn't able figure it out.

-- 
Kalle Valo
