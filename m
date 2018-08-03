Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:18334 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbeHCGY3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Aug 2018 02:24:29 -0400
Date: Fri, 3 Aug 2018 09:59:56 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>
Subject: Re: [PATCH] staging: wilc1000: fix compilation warning for ARCH
 PowerPC
Message-ID: <20180803095956.589d9b82@ajaysk-VirtualBox> (sfid-20180803_063008_335206_1B10DE5B)
In-Reply-To: <20180802193116.GA27034@kroah.com>
References: <1533209222-22295-1-git-send-email-ajay.kathat@microchip.com>
        <20180802193116.GA27034@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Greg,

On Thu, 2 Aug 2018 21:31:16 +0200
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Thu, Aug 02, 2018 at 04:57:02PM +0530, Ajay Singh wrote:
> > Fix below warning reported for PowerPC arch compilation
> > 
> > include/uapi/linux/byteorder/big_endian.h:95:37: warning: passing
> > argument 1 of '__swab32s' makes pointer from integer without a cast
> > [-Wint-conversion]
> > 
> > Fixes: 02211edc9a1f ("staging: wilc1000: fix endianness warnings
> > reported by sparse")
> > 
> > Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> > ---  
> 
> You forgot the reported-by: line :(
> 

Sorry for the trouble.

> I'll go add it, but be more careful in the future please.
> 

Thank you for adding it up. I will take care in future patches.

Regards,
Ajay
