Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42644 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752141AbdG1Plb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 11:41:31 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: remove dummy function call
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170628075711.GA8101@symbol-HP-ZBook-15>
References: <20170628075711.GA8101@symbol-HP-ZBook-15>
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
        linux-wireless@vger.kernel.org
Message-Id: <20170728154130.D551F6090D@smtp.codeaurora.org> (sfid-20170728_174134_914305_D81C3710)
Date: Fri, 28 Jul 2017 15:41:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Souptick Joarder <jrdr.linux@gmail.com> wrote:

> _rtl92cu_init_usb_aggregation() can be removed as it is dummy one
> 
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

f81372ed8b1e rtlwifi: remove dummy function call

-- 
https://patchwork.kernel.org/patch/9813583/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
