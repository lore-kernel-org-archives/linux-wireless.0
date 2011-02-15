Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47245 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab1BOPsl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 10:48:41 -0500
Received: by eye27 with SMTP id 27so161516eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 07:48:40 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] p54: Fix compile warning
Date: Tue, 15 Feb 2011 16:48:30 +0100
Cc: John W Linville <linville@tuxdriver.com>
References: <4d5a9da2.T52RN9mbp1TlCDQm%Larry.Finger@lwfinger.net>
In-Reply-To: <4d5a9da2.T52RN9mbp1TlCDQm%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201102151648.31421.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 15 February 2011 16:37:06 Larry Finger wrote:
> If any of the p54-based drivers are built with CONFIG_P54_LEDS not
> defined, the following warning is generated:
> 
>   CC [M]  drivers/net/wireless/p54/main.o
> drivers/net/wireless/p54/main.c: In function ‘p54_register_common’:
> drivers/net/wireless/p54/main.c:614:21: warning: unused variable ‘priv’
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> V2 - use __maybe_unused instead of conditional compilation
well, there is a third option [use the priv in the dev_info)
However, this approach is fine too.

Regards,
	Chr

BTW, John... What's your ?WG511? doing?
