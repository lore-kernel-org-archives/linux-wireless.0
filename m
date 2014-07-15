Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51984 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaGOVAS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2014 17:00:18 -0400
Date: Tue, 15 Jul 2014 16:58:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Chen-Yu Tsai <wens@csie.org>, linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH v4 0/4] brcmfmac: OOB interrupt support
Message-ID: <20140715205841.GG26012@tuxdriver.com> (sfid-20140715_230025_054504_44FA2FA0)
References: <1404051421-24377-1-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404051421-24377-1-git-send-email-hdegoede@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch "brcmfmac: Cleanup used device IDs." makes this series
not build.  Unfortunately, I already merged that one...

Would you mind rebasing/reposting this?

Sorry...

John

On Sun, Jun 29, 2014 at 04:16:57PM +0200, Hans de Goede wrote:
> Hi All,
> 
> Here is v2 of the brcmfmac: OOB interrupt support series.
> 
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

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
