Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41964 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752195AbeEOIWj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 04:22:39 -0400
Date: Tue, 15 May 2018 11:22:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Cc: Ajay Singh <ajay.kathat@microchip.com>, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org, ganesh.krishna@microchip.com,
        adham.abozaeid@microchip.com, aditya.shankar@microchip.com
Subject: Re: [PATCH 03/30] staging: wilc1000: fix line over 80 chars in
 handle_key()
Message-ID: <20180515082224.slpj6v5vg2acbzu3@mwanda> (sfid-20180515_102338_387275_2E5D6935)
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
 <1525682614-3824-4-git-send-email-ajay.kathat@microchip.com>
 <1c7fbd1f-a655-a96a-5d2c-50cca9087023@microchip.com>
 <20180510000609.07dcb5a2@ajaysk-VirtualBox>
 <ba9df0c4-e6b3-f858-7c90-06926546d7b7@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ba9df0c4-e6b3-f858-7c90-06926546d7b7@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 10, 2018 at 08:21:52AM +0300, Claudiu Beznea wrote:
> >>> +	wid.val = (s8 *)key_buf;  
> >>
> >> Is this cast really needed?
> >>
> > 
> > This patch is only to address line over 80 chars checkpatch issue.
> > It is not good to club these change with type cast related
> > modification. For removing unnecessary cast we can submit
> > a separate patch series.
> > These are my views. What do you think?
> > 
> 
> I'm ok with this. I was thinking that since you introduced this new function
> you may want to also address this, if any.

No.  Please don't.  That kind of thing is sort of an unrelated change
from just moving the lines around and it messes up my review scripts.

It's really really easy to review the changes when they're split into
multiple chunks.

regards,
dan carpenter
