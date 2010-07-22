Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53824 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab0GVIpl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 04:45:41 -0400
Received: by bwz1 with SMTP id 1so716029bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jul 2010 01:45:40 -0700 (PDT)
Message-ID: <4C48053A.6080504@adurom.com>
Date: Thu, 22 Jul 2010 10:45:46 +0200
From: Kalle Valo <kvalo@adurom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: [PATCH] wl1251: fix sparse-generated warnings
References: <1279729917-4451-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1279729917-4451-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On 07/21/2010 06:31 PM, John W. Linville wrote:
> @@ -225,7 +225,7 @@ static void wl1251_boot_set_ecpu_ctrl(struct wl1251 *wl, u32 flag)
>  int wl1251_boot_run_firmware(struct wl1251 *wl)
>  {
>  	int loop, ret;
> -	u32 chip_id, interrupt;
> +	u32 chip_id, acx_intr;

I don't get why you did this change. I don't object renaming the
variable, but I can't figure out the reasoning behind it.

Kalle
