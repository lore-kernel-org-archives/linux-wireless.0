Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:35796 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbeFEIgJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Jun 2018 04:36:09 -0400
Date: Tue, 5 Jun 2018 11:35:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thibaut Robert <thibaut.robert@gmail.com>
Cc: Ajay Singh <ajay.kathat@microchip.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Aditya Shankar <aditya.shankar@microchip.com>
Subject: Re: [PATCH 1/1] staging: wilc1000: Use common structs to parse ip
 packets
Message-ID: <20180605083551.n6kmljbfxfc7vv2c@mwanda> (sfid-20180605_103729_886914_2DB95D14)
References: <20180529190839.12818-1-thibaut.robert@gmail.com>
 <20180530112904.x4vcpkdmqhpc7xll@mwanda>
 <20180604105549.04031722@ajaysk-VirtualBox>
 <20180604192702.GA32753@L80496>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20180604192702.GA32753@L80496>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 04, 2018 at 09:27:02PM +0200, Thibaut Robert wrote:
> Le lundi 04 juin 2018 à 10:55:49 (+0530), Ajay Singh a écrit :
> > 
> > Thank you for submitting the patches.
> > 
> > The modification in this patch looks okay to me.
> > Please resend this by including changes as suggested by Dan.
> > I can do the modification and resubmit this patch by including review
> > comments, if its okay with you.
> > 
> Sorry, I would like to address the comments, but still had no time to do it correctly. I
> am doing this as a hobby and am still learning so forgive me for the delay. 
> If you can wait a little bit more, I'll resend an updated version.
> 
> Thanks for your time !

When you're a kernel dev, you sometimes do get the feeling that everyone
is waiting for you.  We're not.  There is no rush.  We read through your
email and reply and then it's gone from our mind like dust in the wind.
There is never a rush and you will never run out of more work to do.

Plus the merge window is open so Greg won't even look at it for the next
several weeks.

Take all the time you need.

I normally write a patch, then wait until morning so I can review it
with fresh eyes before sending it.  If I wait longer than a day, though,
I forget what the issue is and I have to retest it from scratch.  After
one day in my outbox a patch gets old and boring so those are low
quality.  If it's a cleanup patch, I'll probably just delete it instead.

regards,
dan carpenter
