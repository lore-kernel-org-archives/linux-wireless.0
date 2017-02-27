Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38040 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751251AbdB0QZd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 11:25:33 -0500
Message-ID: <1488211573.28431.21.camel@sipsolutions.net> (sfid-20170227_172537_003493_BD90DD22)
Subject: Re: BUG_ON in sg code
From: Johannes Berg <johannes@sipsolutions.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 27 Feb 2017 17:06:13 +0100
In-Reply-To: <CAKv+Gu8zSARqLY6-_XRQAC2tY0DWuYpARG0deUGLsu3qoa2AVw@mail.gmail.com> (sfid-20170227_161021_926551_7998E731)
References: <1488207986.28431.17.camel@sipsolutions.net>
         <CAKv+Gu8zSARqLY6-_XRQAC2tY0DWuYpARG0deUGLsu3qoa2AVw@mail.gmail.com>
         (sfid-20170227_161021_926551_7998E731)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-02-27 at 15:10 +0000, Ard Biesheuvel wrote:
> 
> > because you put odata/idata on the stack. What's going on there? I
> > thought we knew we can't do that? Did I miss something?
> > 
> 
> It was I who missed something, obviously.

Ok. I thought maybe I missed a plan to actually make it allowed or
something :)

Thanks!

johannes
