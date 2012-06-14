Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:63456 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754897Ab2FNCIN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 22:08:13 -0400
MIME-Version: 1.0
In-Reply-To: <1339638523-17971-1-git-send-email-Woody.Hung@mediatek.com>
References: <1339638523-17971-1-git-send-email-Woody.Hung@mediatek.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 14 Jun 2012 12:07:51 +1000
Message-ID: <CAGRGNgVYT=+E9Sp2dN+z+2WH2GDN1Nec9t7b_+Ldmi6BajJz5Q@mail.gmail.com> (sfid-20120614_040834_538565_D6609269)
Subject: Re: [PATCH] rt2800pci:Firmware update
To: Woody Hung <Woody.Hung@mediatek.com>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
	gwingerde@gmail.com, xose.vazquez@gmail.com,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Woody,

I assume this is for the linux-firmware repository, you should CC them
and mention this in the subject.

On Thu, Jun 14, 2012 at 11:48 AM, Woody Hung <Woody.Hung@mediatek.com> wrote:
> Update firmwrae that support the rt3290 chip.
>
> Signed-off-by: Woody Hung <Woody.Hung@mediatek.com>
> ---
>  rt3290.bin |  Bin 0 -> 4096 bytes
>  1 files changed, 0 insertions(+), 0 deletions(-)
>  create mode 100644 rt3290.bin

Due to the legal issues with most firmware images, the linux-firmware
repository has it's own strict rules and regulations.

Your patch will never be applied if it does not follow these rules.

See here:

https://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=blob;f=README;h=0ed6d79c74a1be29d2fcce9be9a62acd6df3fd4e;hb=HEAD

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
