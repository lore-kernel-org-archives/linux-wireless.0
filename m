Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39194 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752549AbeAaO6V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jan 2018 09:58:21 -0500
Date: Wed, 31 Jan 2018 17:57:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Colin King <colin.king@canonical.com>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wireless: zd1211rw: remove redundant assignment of
 pointer 'q'
Message-ID: <20180131145747.vyi5zscxqt3aa5lz@mwanda> (sfid-20180131_155844_782620_1A2AA371)
References: <20180130182537.5580-1-colin.king@canonical.com>
 <CAHp75Vc_8v3qxWjtT4B3Kvz4dNZ8=-+uRPs-iTK3o8Taa4Swgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAHp75Vc_8v3qxWjtT4B3Kvz4dNZ8=-+uRPs-iTK3o8Taa4Swgw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 31, 2018 at 02:58:57PM +0200, Andy Shevchenko wrote:
> On Tue, Jan 30, 2018 at 8:25 PM, Colin King <colin.king@canonical.com> wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> >
> > Pointer q is initialized and then almost immediately afterwards being
> > re-assigned the same value. Remove the second redundant assignment.
> >
> 
> Don't you see strange that in the same context of the patch two users
> of q are present?
> 
> How did you test this?
> 

The patch is obviously correct, I don't understand the question.

regards,
dan carpenter
