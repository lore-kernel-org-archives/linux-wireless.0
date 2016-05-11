Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34941 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbcEKSuo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 14:50:44 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: mwifiex: Drop unnecessary include pcieport_if.h
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <a99f9851b2b0e26d0b8af41a16815d5e28beb217.1462285455.git.lukas@wunner.de>
To: Lukas Wunner <lukas@wunner.de>
Cc: linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Message-Id: <20160511185043.96E226131E@smtp.codeaurora.org> (sfid-20160511_205048_316660_D882BAAD)
Date: Wed, 11 May 2016 18:50:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lukas Wunner <lukas@wunner.de> wrote:
> This header file is only needed for drivers binding to a PCI bridge
> device allocated by drivers/pci/pcie/portdrv_core.c. The mwifiex driver
> doesn't do that nor use any symbols defined in pcieport_if.h.
> 
> Cc: Amitkumar Karwar <akarwar@marvell.com>
> Cc: Nishant Sarmukadam <nishants@marvell.com>
> Signed-off-by: Lukas Wunner <lukas@wunner.de>

Thanks, 1 patch applied to wireless-drivers-next.git:

30cfe9f61c2e mwifiex: Drop unnecessary include pcieport_if.h

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9007981/

