Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57338 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752516AbcICKIW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 06:08:22 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rt2x00usb: Fix error return code
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1470926334-24532-1-git-send-email-christophe.jaillet@wanadoo.fr>
To: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Cc: sgruszka@redhat.com, helmut.schaa@googlemail.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-Id: <20160903100705.35E6B62023@smtp.codeaurora.org> (sfid-20160903_120854_619320_8C77645C)
Date: Sat,  3 Sep 2016 10:07:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christophe Jaillet <christophe.jaillet@wanadoo.fr> wrote:
> We know that 'retval = 0' because it has been tested a few lines above.
> So, if 'devm_kmalloc' fails, 0 will be returned instead of an error code.
> Return -ENOMEM instead.
> 
> Fixes: 8b4c0009313f ("rt2x00usb: Use usb anchor to manage URB")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

410280bac622 rt2x00usb: Fix error return code

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9275379/
