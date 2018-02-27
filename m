Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44336 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753307AbeB0Nvs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 08:51:48 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/6] wl1251: Update wl->nvs_len after wl->nvs is valid
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1510270708-14377-2-git-send-email-pali.rohar@gmail.com>
References: <1510270708-14377-2-git-send-email-pali.rohar@gmail.com>
To: =?utf-8?q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Gnedt <david.gnedt@davizone.at>,
        Michal Kazior <michal.kazior@tieto.com>,
        Daniel Wagner <wagi@monom.org>,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sre@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Grazvydas Ignotas <notasas@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Message-Id: <20180227135148.07B0E60F6D@smtp.codeaurora.org> (sfid-20180227_145318_216645_4D1FD199)
Date: Tue, 27 Feb 2018 13:51:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pali Rohár wrote:

> If kmemdup fails, then wl->nvs_len will contain invalid non-zero size.
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>

4 patches applied to wireless-drivers-next.git, thanks.

f63b4c971f5f wl1251: Update wl->nvs_len after wl->nvs is valid
562da3a39cb7 wl1251: Generate random MAC address only if driver does not have valid
4f507d588d08 wl1251: Parse and use MAC address from supplied NVS data
3142467fc15b wl1251: Set generated MAC address back to NVS data

-- 
https://patchwork.kernel.org/patch/10052101/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
