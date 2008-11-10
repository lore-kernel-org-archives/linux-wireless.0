Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:3003 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbYKJSCG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 13:02:06 -0500
Received: by yw-out-2324.google.com with SMTP id 9so950304ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Nov 2008 10:02:04 -0800 (PST)
Message-ID: <40f31dec0811101002u7e2ec485vb4d2954cfa2ed6e2@mail.gmail.com> (sfid-20081110_190216_508520_B7F8CD17)
Date: Mon, 10 Nov 2008 20:02:04 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] ath5k: name pci driver "ath5k" too
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1226339820.3650.9.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1226339820.3650.9.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/11/10 Johannes Berg <johannes@sipsolutions.net>:
> Call the ath5k pci driver struct "ath5k" too to be less
> confusing in sysfs.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> resend, forgot the list
>
>  drivers/net/wireless/ath5k/base.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- everything.orig/drivers/net/wireless/ath5k/base.c   2008-11-10 18:54:15.000000000 +0100
> +++ everything/drivers/net/wireless/ath5k/base.c        2008-11-10 18:54:26.000000000 +0100
> @@ -200,7 +200,7 @@ static int          ath5k_pci_resume(struct pci_
>  #endif /* CONFIG_PM */
>
>  static struct pci_driver ath5k_pci_driver = {
> -       .name           = "ath5k_pci",
> +       .name           = KBUILD_MODNAME,
>        .id_table       = ath5k_pci_id_table,
>        .probe          = ath5k_pci_probe,
>        .remove         = __devexit_p(ath5k_pci_remove),
>
>
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
