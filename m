Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47170 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752181AbeCMJ6Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 05:58:16 -0400
Date: Tue, 13 Mar 2018 10:58:16 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: hariprasath.elango@gmail.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, vbabu3@visteon.com,
        linux-wireless@vger.kernel.org,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        aditya.shankar@microchip.com
Subject: Re: [PATCHv2] staging: wilc1000: use pre-defined macro
 is_broadcast_ether_addr
Message-ID: <20180313095816.GA1656@kroah.com> (sfid-20180313_105827_795304_461724D2)
References: <20180312093903.9147-1-hariprasath.elango@gmail.com>
 <20180313130051.43b087dd@ajaysk-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180313130051.43b087dd@ajaysk-VirtualBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 13, 2018 at 01:00:51PM +0530, Ajay Singh wrote:
> 
> Reviewed-by: Ajay Singh <ajay.kathat@microchip.com>
> 
> On Mon, 12 Mar 2018 15:09:03 +0530
> <hariprasath.elango@gmail.com> wrote:
> 
> > From: HariPrasath Elango <hariprasath.elango@gmail.com>
> >
> 
> Please avoid use of 'From' tag specially when there is only one
> 'Signed-off-by' tag and its same.

But the email client isn't putting the correct info in the email header,
so this line is needed.

And if it's redundant, not a problem, git handles it just fine, better
to be safe.

thanks,

greg k-h
