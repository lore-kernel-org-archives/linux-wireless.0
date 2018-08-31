Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34254 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727957AbeHaTzw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 15:55:52 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] rt2x00: use simple_read_from_buffer()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180822104126.2logh4tqxkmiomqy@kili.mountain>
References: <20180822104126.2logh4tqxkmiomqy@kili.mountain>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-Id: <20180831154746.482A460242@smtp.codeaurora.org> (sfid-20180831_174755_624372_F5AE70A3)
Date: Fri, 31 Aug 2018 15:47:46 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> wrote:

> The problem with this copy_to_user() calls is that they don't ensure
> that "size" is less than the "length" which the user provided.
> 
> Obviously, this is debugfs and "size" is normally going to be very small
> so it probably doesn't matter, but this is the correct thing to do.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

f483039cf51a rt2x00: use simple_read_from_buffer()

-- 
https://patchwork.kernel.org/patch/10572845/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
