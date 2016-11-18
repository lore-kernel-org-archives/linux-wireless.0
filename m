Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42960 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932255AbcKRQVr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 11:21:47 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, <devicetree@vger.kernel.org>,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH v8] mwifiex: parse device tree node for PCIe
References: <1479472624-22340-1-git-send-email-akarwar@marvell.com>
Date: Fri, 18 Nov 2016 18:21:41 +0200
In-Reply-To: <1479472624-22340-1-git-send-email-akarwar@marvell.com>
        (Amitkumar Karwar's message of "Fri, 18 Nov 2016 18:07:04 +0530")
Message-ID: <87oa1coj1m.fsf@purkki.adurom.net> (sfid-20161118_172153_740178_AB01669D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

> From: Xinming Hu <huxm@marvell.com>
>
> This patch derives device tree node from pcie bus layer framework.
> Device tree bindings file has been renamed(marvell-sd8xxx.txt ->
> marvell-8xxx.txt) to accommodate PCIe changes.
>
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Rajat Jain <rajatja@google.com>
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

[...]

> @@ -10,6 +10,8 @@ Required properties:
>    - compatible : should be one of the following:
>  	* "marvell,sd8897"
>  	* "marvell,sd8997"
> +	* "pci11ab,2b42"
> +	* "pci1b4b,2b42"

Are these correct? In v6 Rob said:

"I think I already said this, but you have the vendor and product IDs 
reversed."

https://patchwork.kernel.org/patch/9390225/

-- 
Kalle Valo
