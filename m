Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39911 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbaE0PaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 11:30:19 -0400
Date: Tue, 27 May 2014 11:26:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
	Chris Ball <chris@printf.net>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Arend van Spriel <arend@broadcom.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>,
	linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH 00/11] sdio wifi oob irq support for sunxi
Message-ID: <20140527152614.GB5694@tuxdriver.com> (sfid-20140527_173024_376431_697BB987)
References: <1401090486-4414-1-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401090486-4414-1-git-send-email-hdegoede@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 26, 2014 at 09:47:55AM +0200, Hans de Goede wrote:
> Hi All,
> 
> Here is a patch series adding support for oob irqs for the ap6210 sdio wifi
> modules found on various Allwinner A20 boards.
> 
> A lot of it is ground work which should be useful for adding oob irq support
> to other sdio wifi models too.
> 
> The first 5 patches are sunxi pinctrl patches and should go upstream through
> the pinctrl tree.
> 
> Patch 6 adds generic support for having per sdio function child nodes in
> devicetree and should go upstream through the mmc tree.
> 
> Patch 7 and 8 add oob irq support to the brcmfmac driver. Patch 9 pokes some
> magic bits needed to enable the oob irq, this was taken from an android code
> dump and good do with a good review from someone from Broadcom, Arend ?

If Arend approves, I'm fine with these going through another appropriate tree.

> Patch 10 and 11 add the necessary dts bits to actually enable the sdio irq
> and should go upstream through Maxime's dt tree.
> 
> Please review / merge.
> 
> Thanks & Regards,
> 
> Hans
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
