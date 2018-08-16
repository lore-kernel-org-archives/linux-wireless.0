Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57302 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbeHPJkO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Aug 2018 05:40:14 -0400
Date: Thu, 16 Aug 2018 08:43:54 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        ganesh.krishna@microchip.com, aditya.shankar@microchip.com,
        nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        adham.abozaeid@microchip.com
Subject: Re: feedback on mainlining wilc1000 staging driver
Message-ID: <20180816064354.GA2564@kroah.com> (sfid-20180816_084400_959708_E0BF5944)
References: <20180816015243.545cd009@ajaysk-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180816015243.545cd009@ajaysk-VirtualBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 16, 2018 at 01:52:43AM +0530, Ajay Singh wrote:
> Hi Greg,
> 
> We all are working on submitting and reviewing patches for wilc1000 in
> staging driver for quite some time. 
> 
> We would like to have feedback on the next steps to bring wilc1000
> driver closer to move into the wireless subsystem tree. 

<snip>

It is the middle of the merge window, combined with all of the 1ltf
crap, and other stable stuff.  Can you wait until after the merge window
for this please?  There's nothing we can do now anyway.  Submit the rest
of your pending patches, get those merged and then we can review the
code to see what you have left to do.

thanks,

greg k-h
