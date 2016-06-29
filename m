Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46485 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbcF2RBr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 13:01:47 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>, linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH 2/4] ARM: dts: sun7i-a20-cubietruck: Set brcm,nvram_file_name
References: <1467209074-15634-1-git-send-email-hdegoede@redhat.com>
	<1467209074-15634-2-git-send-email-hdegoede@redhat.com>
Date: Wed, 29 Jun 2016 20:01:13 +0300
In-Reply-To: <1467209074-15634-2-git-send-email-hdegoede@redhat.com> (Hans de
	Goede's message of "Wed, 29 Jun 2016 16:04:32 +0200")
Message-ID: <87wpl8c4km.fsf@purkki.adurom.net> (sfid-20160629_190211_605856_A33108D1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hans de Goede <hdegoede@redhat.com> writes:

> The cubietruck uses an ap6210 sdio wifi module, set brcm,nvram_file_name
> to brcmfmac43362-ap6210.txt so that we can ship the ap6210 specific
> nvram file in linunx-firmware to get the wifi to work out of the box
> without users needing to download and install the nvram file themselves.
>
> Note a downside of this patch is that users who have already manually
> installed the nvram file will need to rename it.
>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  arch/arm/boot/dts/sun7i-a20-cubietruck.dts | 1 +
>  1 file changed, 1 insertion(+)

I can't apply .dts changes so better to send them in a separate
patchset.

-- 
Kalle Valo
