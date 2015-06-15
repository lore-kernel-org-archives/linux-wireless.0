Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51862 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbbFOJnw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 05:43:52 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/4] brcmfmac: Update msgbuf read pointer quicker.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1433767115-8136-2-git-send-email-arend@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Message-Id: <20150615094351.D8C53140926@smtp.codeaurora.org> (sfid-20150615_114355_637054_F688BFFB)
Date: Mon, 15 Jun 2015 09:43:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Hante Meuleman <meuleman@broadcom.com>
> 
> On device to host data using msgbuf the read pointer gets updated
> once all data is processed. Updating this pointer more frequently
> allows the firmware to add more data quicker. This will result in
> slightly higher and more stable throughput on CPU bounded host
> processors.
> 
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks, 4 patches applied to wireless-drivers-next.git:

df738c2f0cbf brcmfmac: Update msgbuf read pointer quicker.
dbf967537dce brcmfmac: remove chipinfo debugfs entry
c161f29bd69f brcmfmac: remove watchdog reset from brcmf_pcie_buscoreprep()
5b18ffb2d725 brcmfmac: use debugfs_create_devm_seqfile() helper function

Kalle Valo
