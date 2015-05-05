Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36472 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069AbbEEUE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 16:04:27 -0400
Received: by wgiu9 with SMTP id u9so32313824wgi.3
        for <linux-wireless@vger.kernel.org>; Tue, 05 May 2015 13:04:26 -0700 (PDT)
Message-ID: <55492249.2070900@gmail.com> (sfid-20150505_220437_859397_BA4CE8BA)
Date: Tue, 05 May 2015 22:04:25 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Jes Sorensen <Jes.Sorensen@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/1] New driver: rtl8723au (mac80211)
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen wrote:

> [...]
> diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
> index 0c88916..e3911cc 100644
> --- a/drivers/net/wireless/Makefile
> +++ b/drivers/net/wireless/Makefile
> @@ -39,6 +39,8 @@ obj-$(CONFIG_LIBERTAS_THINFIRM)	+= libertas_tf/
>  
>  obj-$(CONFIG_ADM8211)	+= adm8211.o
>  
> +obj-$(CONFIG_RTL8XXXU)	+= rtl8xxxu.o
> +
> [...]

rtl8xxxu is a really bad name.

You can see at: https://wireless.wiki.kernel.org/en/users/drivers/rtl819x
the normalized nomenclature for realtek drivers.
