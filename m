Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54980 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753441AbcIIJTA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 05:19:00 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: add PCIe function level reset support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1469541704-2880-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160909091859.C392261BBF@smtp.codeaurora.org> (sfid-20160909_111905_937179_AD585693)
Date: Fri,  9 Sep 2016 09:18:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> This patch implements pre and post FLR handlers to support PCIe FLR
> functionality. Software cleanup is performed in pre-FLR whereas
> firmware is downloaded and software is re-initialised in
> post-FLR handler.
> 
> Following command triggers FLR.
> echo "1" > /sys/bus/pci/devices/$NUMBER/reset
> 
> This feature can be used as a recovery mechanism when firmware gets
> hang.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

4c5dae59d2e9 mwifiex: add PCIe function level reset support

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9248233/
