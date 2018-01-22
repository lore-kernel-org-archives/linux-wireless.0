Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58450 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750886AbeAVLWr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 06:22:47 -0500
Date: Mon, 22 Jan 2018 14:22:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Cc: Ajay Singh <ajay.kathat@microchip.com>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, venkateswara.kaja@microchip.com,
        aditya.shankar@microchip.com, ganesh.krishna@microchip.com
Subject: Re: [PATCH v2 02/14] staging: wilc1000: removed unnecessary defined
 enums typedef
Message-ID: <20180122112234.33sod7nfy7ps3pq4@mwanda> (sfid-20180122_122251_576697_EA5B125A)
References: <1516616547-24654-1-git-send-email-ajay.kathat@microchip.com>
 <1516616547-24654-3-git-send-email-ajay.kathat@microchip.com>
 <90847f2f-449e-b34a-4a86-880e2b3670d7@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <90847f2f-449e-b34a-4a86-880e2b3670d7@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 22, 2018 at 01:06:59PM +0200, Claudiu Beznea wrote:
> 
> 
> On 22.01.2018 12:22, Ajay Singh wrote:
> > Fix the "do not add new typedefs" issue found by checkpatch.pl
> > script
> > 
> >From https://www.kernel.org/doc/html/latest/process/submitting-patches.html#the-canonical-patch-format
> the the message body line is wrapped at 75 columns.
> 

I normally consider 75 characters a maximum.  I wrap at 72 characters
like a normal email.

If we get too hung up on procedures for their own sake then it makes
sending patches a real pain.  There are some people I just don't send
patches to because they are too much headache to deal with.

regards,
dan carpenter
