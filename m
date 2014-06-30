Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:45206 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbaF3IP6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2014 04:15:58 -0400
Message-ID: <53B11CBA.3010501@broadcom.com> (sfid-20140630_101602_698443_1AF24E2A)
Date: Mon, 30 Jun 2014 10:15:54 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: Chen-Yu Tsai <wens@csie.org>, <linux-wireless@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	devicetree <devicetree@vger.kernel.org>,
	<linux-sunxi@googlegroups.com>
Subject: Re: [PATCH v4 0/4] brcmfmac: OOB interrupt support
References: <1404051421-24377-1-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1404051421-24377-1-git-send-email-hdegoede@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29-06-14 16:16, Hans de Goede wrote:
> Hi All,
> 
> Here is v2 of the brcmfmac: OOB interrupt support series.

I guess this could use an update :-p

Regards,
Arend

> Changes since v1:
> -Post as a stand alone series, rather then together with sunxi pinctrl changes,
>  etc.
> -Add a patch to fixup the names of the register addresses used in the
>  "brcmfmac: Fix OOB interrupt not working for BCM43362" patch
> -Use the new register names in:
>  "brcmfmac: Fix OOB interrupt not working for BCM43362"
> 
> Changes since v2:
> -"dt: bindings: add bindings for Broadcom bcm43xx sdio devices"
>  * changed the compatible string to brcm,bcm4329-fmac
>  * replaced the dt-bindings example with a real world example
> -"brcmfmac: Fix OOB interrupt not working for BCM43362"
>  * updated commit message with confirmation from broadcom that this is the
>    right thing to do
> 
> Regards,
> 
> Hans
> 

