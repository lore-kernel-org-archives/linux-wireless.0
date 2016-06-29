Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbcF2SBQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 14:01:16 -0400
Subject: Re: [linux-sunxi] Re: [PATCH 2/4] ARM: dts: sun7i-a20-cubietruck: Set
 brcm,nvram_file_name
To: Kalle Valo <kvalo@codeaurora.org>
References: <1467209074-15634-1-git-send-email-hdegoede@redhat.com>
 <1467209074-15634-2-git-send-email-hdegoede@redhat.com>
 <87wpl8c4km.fsf@purkki.adurom.net>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>, linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <e0355531-d727-ea7f-0930-22b47c568a5a@redhat.com> (sfid-20160629_200119_356316_FD3D946D)
Date: Wed, 29 Jun 2016 20:01:02 +0200
MIME-Version: 1.0
In-Reply-To: <87wpl8c4km.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HI,

On 29-06-16 19:01, Kalle Valo wrote:
> Hans de Goede <hdegoede@redhat.com> writes:
>
>> The cubietruck uses an ap6210 sdio wifi module, set brcm,nvram_file_name
>> to brcmfmac43362-ap6210.txt so that we can ship the ap6210 specific
>> nvram file in linunx-firmware to get the wifi to work out of the box
>> without users needing to download and install the nvram file themselves.
>>
>> Note a downside of this patch is that users who have already manually
>> installed the nvram file will need to rename it.
>>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>>  arch/arm/boot/dts/sun7i-a20-cubietruck.dts | 1 +
>>  1 file changed, 1 insertion(+)
>
> I can't apply .dts changes so better to send them in a separate
> patchset.

Maxime Ripard who is in the Cc maintains the dts files
in question, I've send these as one set because I find
that sending out actual dts usage examples helps.

Regards,

Hans

