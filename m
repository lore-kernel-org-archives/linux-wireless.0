Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57366 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbcGHNre (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 09:47:34 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: Change default firmware for PCIe8997 chipset
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1467305697-2371-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Cathy Luo <cluo@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160708134733.DB7E7611CB@smtp.codeaurora.org> (sfid-20160708_154738_210917_09A482DF)
Date: Fri,  8 Jul 2016 13:47:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> PCIe-USB8997 variant is being used in the product. Let's change default
> firmware from PCIe-UART to PCIe-USB. So by default PCIe-USB firmware would
> be downloaded if version register doesn't give any information.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

473dfbfa0993 mwifiex: Change default firmware for PCIe8997 chipset

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9208641/

