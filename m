Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50048 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753830AbcIIL1A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 07:27:00 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: PCIe8997 chip specific handling
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1469788731-5361-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160909112659.F015A61821@smtp.codeaurora.org> (sfid-20160909_132709_648524_6BE1245F)
Date: Fri,  9 Sep 2016 11:26:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> The patch corrects the revision id register and uses it along with
> magic value and chip version registers to download appropriate firmware
> image.
> 
> PCIe8997 Z chipset variant code has been removed, as it won't be used in
> production.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

75696fe70477 mwifiex: PCIe8997 chip specific handling

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9252431/
