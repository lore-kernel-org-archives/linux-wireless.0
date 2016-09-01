Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53296 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934029AbcIAPyj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Sep 2016 11:54:39 -0400
Date: Thu, 1 Sep 2016 17:54:47 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Matthias Beyer <mail@beyermatthias.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, shivanib134@gmail.com,
        ksenija.stanojevic@gmail.com, Jes.Sorensen@redhat.com,
        meleodr@gmail.com, bhaktipriya96@gmail.com, bhumirks@gmail.com,
        Larry.Finger@lwfinger.net
Subject: Re: [PATCH] drivers: staging: rtl823au: hal: Remove pointless test
Message-ID: <20160901155447.GB7979@kroah.com> (sfid-20160901_175449_205194_523A64A3)
References: <CAMzoamY0HSt4af8EeJpt73FD++q1MZ7iHJFa4NDBtzzQrNMjbg@mail.gmail.com>
 <20160823194417.30531-1-mail@beyermatthias.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160823194417.30531-1-mail@beyermatthias.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 23, 2016 at 09:44:16PM +0200, Matthias Beyer wrote:
> As reported by David Binderman, this test is useless as of
> 
>     if (a < 3) {
>         /* ... */
>     } else if (a >= 3) {
>         /* ... */
>     }
> 
> so this patch removes the second check.
> 
> Matthias Beyer (1):
>   drivers: staging: rtl8723au: hal: Remove pointless test
> 
>  drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

There is no patch here :(
