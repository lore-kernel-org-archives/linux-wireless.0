Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:37413 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933320AbcKQRi2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 12:38:28 -0500
Received: by mail-it0-f53.google.com with SMTP id y23so65325283itc.0
        for <linux-wireless@vger.kernel.org>; Thu, 17 Nov 2016 09:38:28 -0800 (PST)
Date: Thu, 17 Nov 2016 09:38:25 -0800
From: Brian Norris <briannorris@chromium.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com,
        dmitry.torokhov@gmail.com, Xinming Hu <huxm@marvell.com>
Subject: Re: [v7] mwifiex: parse device tree node for PCIe
Message-ID: <20161117173824.GA129893@google.com> (sfid-20161117_183838_386715_877ECC15)
References: <1479215662-631-1-git-send-email-akarwar@marvell.com>
 <20161117123920.E159F6162A@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161117123920.E159F6162A@smtp.codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 17, 2016 at 12:39:20PM +0000, Kalle Valo wrote:
> Amitkumar Karwar <akarwar@marvell.com> wrote:
> > From: Xinming Hu <huxm@marvell.com>
> > 
> > This patch derives device tree node from pcie bus layer framework.
> > Device tree bindings file has been renamed(marvell-sd8xxx.txt ->
> > marvell-8xxx.txt) to accommodate PCIe changes.
> > 
> > Signed-off-by: Xinming Hu <huxm@marvell.com>
> > Signed-off-by: Rajat Jain <rajatja@google.com>
> > Reviewed-by: Brian Norris <briannorris@chromium.org>
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> 
> You should CC the device tree list when making changes to the bindings.

FWIW, Rajat had that right on v6...

> Patch set to Changes Requested.

Brian
