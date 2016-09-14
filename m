Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54180 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753297AbcINRDB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 13:03:01 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] mwifiex: Command 7 handling for USB chipsets
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1473686728-8101-2-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160914170300.C2E5761AD5@smtp.codeaurora.org> (sfid-20160914_190304_325594_3B57F2CA)
Date: Wed, 14 Sep 2016 17:03:00 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> From: Ganapathi Bhat <gbhat@marvell.com>
> 
> Firmware image for newer USB chipsets starts with a command 7 block
> (special command). It doesn't contain data length field. This patch adds
> necessary handling.
> 
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 2 patches applied to wireless-drivers-next.git:

787764676f94 mwifiex: Command 7 handling for USB chipsets
b7450e248d71 mwifiex: firmware name correction for usb8997 chipset

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9326515/
