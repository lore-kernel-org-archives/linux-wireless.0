Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:60468 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbaE0Qu7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 12:50:59 -0400
Message-ID: <5384C25E.70505@broadcom.com> (sfid-20140527_185117_133557_2029624A)
Date: Tue, 27 May 2014 18:50:38 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Hans de Goede <hdegoede@redhat.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Chris Ball <chris@printf.net>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-mmc@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	devicetree <devicetree@vger.kernel.org>,
	<linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 00/11] sdio wifi oob irq support for sunxi
References: <1401090486-4414-1-git-send-email-hdegoede@redhat.com> <20140527152614.GB5694@tuxdriver.com>
In-Reply-To: <20140527152614.GB5694@tuxdriver.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/27/14 17:26, John W. Linville wrote:
> On Mon, May 26, 2014 at 09:47:55AM +0200, Hans de Goede wrote:
>> Hi All,
>>
>> Here is a patch series adding support for oob irqs for the ap6210 sdio wifi
>> modules found on various Allwinner A20 boards.
>>
>> A lot of it is ground work which should be useful for adding oob irq support
>> to other sdio wifi models too.
>>
>> The first 5 patches are sunxi pinctrl patches and should go upstream through
>> the pinctrl tree.
>>
>> Patch 6 adds generic support for having per sdio function child nodes in
>> devicetree and should go upstream through the mmc tree.
>>
>> Patch 7 and 8 add oob irq support to the brcmfmac driver. Patch 9 pokes some
>> magic bits needed to enable the oob irq, this was taken from an android code
>> dump and good do with a good review from someone from Broadcom, Arend ?
>
> If Arend approves, I'm fine with these going through another appropriate tree.

Not sure in what tree these patches were created (assume some sunxi 
tree), but if it conflicts with wireless-next I am pretty sure Stephen 
will find that. I am fine with any tree. Patch 9 indeed has some magic 
bits that need some clarification, but I will sort that out with Hans.

Regards,
Arend

>> Patch 10 and 11 add the necessary dts bits to actually enable the sdio irq
>> and should go upstream through Maxime's dt tree.
>>
>> Please review / merge.
>>
>> Thanks&  Regards,
>>
>> Hans
>>
>

