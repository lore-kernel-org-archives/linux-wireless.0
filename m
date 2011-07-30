Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:42832 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab1G3Xoj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jul 2011 19:44:39 -0400
Received: by mail-pz0-f42.google.com with SMTP id 37so8757470pzk.1
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jul 2011 16:44:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4e3431a3.okCWfww1KPoiQhgM%Larry.Finger@lwfinger.net>
References: <4e3431a3.okCWfww1KPoiQhgM%Larry.Finger@lwfinger.net>
Date: Sun, 31 Jul 2011 01:44:38 +0200
Message-ID: <CACna6rxA=UxT68Nmp1GOUmgVXiFeEhK0uw1taFk3YBqv9=t82g@mail.gmail.com> (sfid-20110731_014510_635387_76DCF9A7)
Subject: Re: [PATCH] b43: Remove EXPERIMENTAL designation from LP PHY selection
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/7/30 Larry Finger <Larry.Finger@lwfinger.net>:
> Since kernel 3.0, the problems with controlling b43 devices that have
> low-power (LP) PHYs have been fixed and the EXPERIMENTAL designation
> can be fixed.
>
> This patch also fixes a typo as the device supports 802.11b communications.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>
> Index: wireless-testing-new/drivers/net/wireless/b43/Kconfig
> ===================================================================
> --- wireless-testing-new.orig/drivers/net/wireless/b43/Kconfig
> +++ wireless-testing-new/drivers/net/wireless/b43/Kconfig
> @@ -114,13 +114,13 @@ config B43_PHY_N
>          affect other devices support and may provide support for basic needs.
>
>  config B43_PHY_LP
> -       bool "Support for low-power (LP-PHY) devices (EXPERIMENTAL)"
> -       depends on B43 && EXPERIMENTAL
> +       bool "Support for low-power (LP-PHY) devices"
> +       depends on B43
>        default y
>        ---help---
>          Support for the LP-PHY.
>          The LP-PHY is a low-power PHY built into some notebooks
> -         and embedded devices. It supports 802.11a/g
> +         and embedded devices. It supports 802.11a/b/g
>          (802.11a support is optional, and currently disabled).
>
>  config B43_PHY_HT

Acked-by: Rafał Miłecki <zajec5@gmail.com>

(using text/plain this time)

-- 
Rafał
